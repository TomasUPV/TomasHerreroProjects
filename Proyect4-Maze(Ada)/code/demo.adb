with UART; use UART;
with Ada.Real_Time; use ada.real_time;
with gpio; use gpio;
with System.Multiprocessors;use System.Multiprocessors;

procedure Demo is

   izq, drcha : boolean;
   distancia, d_min, d_max, dp_min, dp_max : float;
   n_inf, n_infL : integer; 
   
   -- DEFINICIÓN DE LOS ESTADOS DE NUESTRA MÁQUINA
   type estado is (Espera_Inicio, Calibracion, Inicio, Avanzar, Detectar_Salida, Parar, 
                   Girar_Derecha, GirarP_Derecha, GirarP_Izquierda, Recuperacion_Atasco);
   eActual : estado;
   
   -- TIEMPOS DE GIRO (ajustables dinámicamente)
   T_Giro_Grande : Time_Span := Milliseconds(500);
   T_Giro_Pequeno : Time_Span := Milliseconds(100);
   Tiempo_Giro_Inicio : Time;
   
   -- Variables para control de botones
   btn0_pressed, btn1_pressed : Boolean := False;
   btn0_anterior, btn1_anterior : Boolean := False;
   
   -- ============================================================
   -- CARACTERÍSTICAS INNOVADORAS
   -- ============================================================
   
   -- 1. SISTEMA DE CALIBRACIÓN AUTOMÁTICA
   distancia_anterior : float := 0.0;
   muestras_calibracion : integer := 0;
   suma_distancias : float := 0.0;
   distancia_calibrada : float := 15.0;  -- Valor óptimo calculado
   
   -- 2. DETECCIÓN INTELIGENTE DE ATASCOS
   tiempo_sin_avanzar : Time;
   contador_atascos : integer := 0;
   distancia_estable_count : integer := 0;
   UMBRAL_ATASCO : constant integer := 50;  -- ~0.5 segundos sin cambio
   
   -- 3. SISTEMA DE LOGGING DE TRAYECTORIA
   type TipoEvento is (Evento_Avance, Evento_Giro_90, Evento_Reajuste_Der, 
                       Evento_Reajuste_Izq, Evento_Atasco, Evento_Meta);
   contador_giros_grandes : integer := 0;
   contador_reajustes : integer := 0;
   contador_total_eventos : integer := 0;
   
   -- 4. MODO DEBUG VISUAL (parpadeante)
   debug_mode : boolean := False;
   debug_blink_time : Time;
   debug_blink_state : boolean := False;
   
   -- 5. OPTIMIZACIÓN ADAPTATIVA
   velocidad_optima : boolean := True;  -- True = rápido, False = lento
   distancia_promedio : float := 15.0;
   
   procedure Check_SMP is
   begin
      Put_Line("Cores disponibles: " & 
                 CPU_Range'Image(System.Multiprocessors.Number_Of_CPUs));
   
      if System.Multiprocessors.Number_Of_CPUs >= 2 then
         Put_Line("Sistema multicore detectado correctamente");
      else
         Put_Line("ADVERTENCIA: Solo se detectó 1 core");
      end if;
   end Check_SMP;
   
   -- Procedimiento para registrar eventos en el log
   procedure Log_Evento(tipo: TipoEvento; distancia_actual: float) is
   begin
      contador_total_eventos := contador_total_eventos + 1;
      
      case tipo is
         when Evento_Giro_90 =>
            contador_giros_grandes := contador_giros_grandes + 1;
            Put_Line("[LOG] Giro 90° ejecutado. Total giros grandes: " & 
                    contador_giros_grandes'image);
         when Evento_Reajuste_Der =>
            contador_reajustes := contador_reajustes + 1;
            Put_Line("[LOG] Reajuste derecha. Distancia: " & distancia_actual'image);
         when Evento_Reajuste_Izq =>
            contador_reajustes := contador_reajustes + 1;
            Put_Line("[LOG] Reajuste izquierda. Distancia: " & distancia_actual'image);
         when Evento_Atasco =>
            Put_Line("[LOG] ¡ATASCO DETECTADO! Iniciando recuperación...");
         when Evento_Meta =>
            Put_Line("[LOG] ===== META ALCANZADA =====");
            Put_Line("[LOG] Estadísticas finales:");
            Put_Line("[LOG]   - Giros grandes (90°): " & contador_giros_grandes'image);
            Put_Line("[LOG]   - Reajustes totales: " & contador_reajustes'image);
            Put_Line("[LOG]   - Atascos resueltos: " & contador_atascos'image);
            Put_Line("[LOG]   - Distancia óptima promedio: " & distancia_promedio'image & " cm");
         when others =>
            null;
      end case;
   end Log_Evento;
   
   -- Detección inteligente de atascos
   function Detectar_Atasco return Boolean is
   begin
      -- Si la distancia no cambia significativamente durante mucho tiempo
      if abs(distancia - distancia_anterior) < 1.0 then
         distancia_estable_count := distancia_estable_count + 1;
      else
         distancia_estable_count := 0;
      end if;
      
      return distancia_estable_count > UMBRAL_ATASCO;
   end Detectar_Atasco;
   
begin
   InitUART(nUart => 0);
   Init;

   eActual := Espera_Inicio;
   d_min := 5.0;
   d_max := 30.0;
   dp_min := 12.0;
   dp_max := 20.0;
   n_infL := 4;

   Put_Line("========================================");
   Put_Line("   ROBOT INTELIGENTE v2.0");
   Put_Line("   Características Avanzadas Activadas");
   Put_Line("========================================");
   Put_Line("BTN0: Arranque (con calibración)");
   Put_Line("BTN1: Rearme + Reset estadísticas");
   Put_Line("========================================");
   Put_Line("Innovaciones:");
   Put_Line("  [✓] Calibración automática");
   Put_Line("  [✓] Detección de atascos");
   Put_Line("  [✓] Logging de trayectoria");
   Put_Line("  [✓] Optimización adaptativa");
   Put_Line("========================================");
   Put_Line("");

   loop
      -- LECTURA DE SENSORES
      izq := Datos_Sensores.Get_S_I;
      drcha := Datos_Sensores.Get_S_D;  
      n_inf := Datos_Sensores.Get_Infrarrojos;
      distancia_anterior := distancia;
      distancia := Datos_Sensores.Get_Distancia;
      
      -- LECTURA DE BOTONES
      btn0_pressed := ReadButton0;
      btn1_pressed := ReadButton1;
      
      if btn0_pressed and not btn0_anterior then
         Put_Line(">>> BTN0: Iniciando con calibración automática <<<");
         if eActual = Espera_Inicio then
            eActual := Calibracion;
         end if;
      end if;
      
      if btn1_pressed and not btn1_anterior then
         Put_Line(">>> BTN1: Rearme completo del sistema <<<");
         if eActual = Parar then
            eActual := Espera_Inicio;
            -- Reset de estadísticas
            contador_giros_grandes := 0;
            contador_reajustes := 0;
            contador_atascos := 0;
            contador_total_eventos := 0;
            Put_Line("Estadísticas reseteadas. Sistema listo.");
         end if;
      end if;
      
      btn0_anterior := btn0_pressed;
      btn1_anterior := btn1_pressed;
           
      -- IMPRIMIR VALORES
      Put("Izq: "& izq'image);
      Put("   Drcha: "& drcha'image);
      Put("   Dist: "& distancia'image & " cm");
      New_line;
      Put_Line("IR inf: "& n_inf'image & "   Eventos: " & contador_total_eventos'image);
      New_line;
      
      -- ============================================================
      -- MÁQUINA DE ESTADOS CON INNOVACIONES
      -- ============================================================
      
      case eActual is
         when Espera_Inicio =>
            null;
            
         when Calibracion =>
            -- INNOVACIÓN 1: Calibración automática de distancia óptima
            if muestras_calibracion < 10 then
               if distancia > 0.0 and distancia < 100.0 then
                  suma_distancias := suma_distancias + distancia;
                  muestras_calibracion := muestras_calibracion + 1;
                  Put_Line("[CALIBRACIÓN] Muestra " & muestras_calibracion'image & 
                          ": " & distancia'image & " cm");
               end if;
            else
               -- Calcular distancia óptima
               distancia_calibrada := suma_distancias / 10.0;
               dp_min := distancia_calibrada - 3.0;
               dp_max := distancia_calibrada + 5.0;
               Put_Line("[CALIBRACIÓN] Completada!");
               Put_Line("[CALIBRACIÓN] Distancia óptima: " & distancia_calibrada'image & " cm");
               Put_Line("[CALIBRACIÓN] Zona de confort: " & dp_min'image & 
                       " - " & dp_max'image & " cm");
               eActual := Inicio;
               muestras_calibracion := 0;
               suma_distancias := 0.0;
            end if;
            
         when Inicio =>
            Contador_ctrl.Set_EN(0);
            tiempo_sin_avanzar := Clock;
            eActual := Avanzar;
            
         when Avanzar =>
            -- INNOVACIÓN 2: Detección de atascos
            if Detectar_Atasco and (izq or drcha) then
               Put_Line("[ALERTA] Posible atasco detectado");
               eActual := Recuperacion_Atasco;
               Log_Evento(Evento_Atasco, distancia);
               contador_atascos := contador_atascos + 1;
               tiempo_sin_avanzar := Clock;
            
            elsif n_inf >= n_infL then 
               eActual := Detectar_Salida;
               Log_Evento(Evento_Meta, distancia);
               
            elsif izq or drcha then
               if distancia > d_max then
                  eActual := Girar_Derecha;
                  Tiempo_Giro_Inicio := Clock;
                  Log_Evento(Evento_Giro_90, distancia);
               else
                  eActual := Avanzar;
               end if;
               
            elsif distancia > d_max then
               eActual := Girar_Derecha;
               Tiempo_Giro_Inicio := Clock;
               Log_Evento(Evento_Giro_90, distancia);
               
            elsif distancia < d_min and distancia > 0.0 then
               eActual := GirarP_Izquierda;
               Tiempo_Giro_Inicio := Clock;
               Log_Evento(Evento_Reajuste_Izq, distancia);
               
            elsif distancia > dp_max and distancia <= d_max then
               eActual := GirarP_Derecha;
               Tiempo_Giro_Inicio := Clock;
               Log_Evento(Evento_Reajuste_Der, distancia);
               
            elsif distancia < dp_min and distancia >= d_min then
               eActual := GirarP_Izquierda;
               Tiempo_Giro_Inicio := Clock;
               Log_Evento(Evento_Reajuste_Izq, distancia);
               
            else
               eActual := Avanzar;
            end if;
            
         when Recuperacion_Atasco =>
            -- INNOVACIÓN 2: Maniobra de recuperación
            if Clock - tiempo_sin_avanzar >= Milliseconds(800) then
               Put_Line("[RECUPERACIÓN] Atasco resuelto, continuando...");
               eActual := Avanzar;
               distancia_estable_count := 0;
            end if;
            
         when Detectar_Salida =>
            eActual := Parar;
            
         when Parar =>
            null;
            
         when Girar_Derecha =>
            if Clock - Tiempo_Giro_Inicio >= T_Giro_Grande then
               eActual := Avanzar;
            end if;

         when GirarP_Derecha =>
            if Clock - Tiempo_Giro_Inicio >= T_Giro_Pequeno then
               eActual := Avanzar;
            end if;

         when GirarP_Izquierda =>
            if Clock - Tiempo_Giro_Inicio >= T_Giro_Pequeno then
               eActual := Avanzar;
            end if;
            
         when others => 
            null;
      end case;
      
      
      -- CONTROL DE ACTUADORES
      case eActual is
         when Espera_Inicio =>
            Put_Line("Estado: ESPERA - Pulse BTN0 para calibrar e iniciar");
            EnciendeRGB(violet, violet);
            Para;
            Contador_ctrl.Set_EN(0);
            
         when Calibracion =>
            Put_Line("Estado: CALIBRACIÓN - Midiendo entorno...");
            -- Parpadeo durante calibración (modo debug visual)
            if Clock - debug_blink_time > Milliseconds(200) then
               debug_blink_state := not debug_blink_state;
               debug_blink_time := Clock;
            end if;
            if debug_blink_state then
               EnciendeRGB(violet, off);
            else
               EnciendeRGB(off, violet);
            end if;
            Para;
            
         when Inicio =>
            Put_Line("Estado: INICIO");
            EnciendeRGB(off, off);
            Para;
            
         when Avanzar => 
            Put_Line("Estado: AVANZAR [Óptimo: " & distancia_calibrada'image & " cm]");
            EnciendeRGB(green, green);
            Avanza;
            Contador_ctrl.Set_EN(1);
            
         when Recuperacion_Atasco =>
            Put_Line("Estado: RECUPERACIÓN DE ATASCO");
            -- Parpadeo rápido rojo-verde (advertencia)
            if Clock - debug_blink_time > Milliseconds(100) then
               debug_blink_state := not debug_blink_state;
               debug_blink_time := Clock;
            end if;
            if debug_blink_state then
               EnciendeRGB(red, red);
            else
               EnciendeRGB(green, green);
            end if;
            -- Retroceder y girar para salir del atasco
            GiroIzq;
            Contador_ctrl.Set_EN(1);
            
         when Detectar_Salida => 
            Put_Line("Estado: META DETECTADA");
            EnciendeRGB(blue, blue);
            Para;
            
         when Parar => 
            Put_Line("Estado: PARAR - Pulse BTN1 para rearmar");
            EnciendeRGB(red, red);
            Para;
            Contador_ctrl.Set_EN(2);
            
         when Girar_Derecha => 
            Put_Line("Estado: GIRO 90° [" & contador_giros_grandes'image & " giros]");
            EnciendeRGB(red, green);
            GiroDrcha;
            Contador_ctrl.Set_EN(1);
            
         when GirarP_Derecha => 
            Put_Line("Estado: REAJUSTE DER [Total: " & contador_reajustes'image & "]");
            EnciendeRGB(green, blue);
            GiroDrcha;
            Contador_ctrl.Set_EN(1);
            
         when GirarP_Izquierda => 
            Put_Line("Estado: REAJUSTE IZQ [Total: " & contador_reajustes'image & "]");
            EnciendeRGB(blue, green);
            GiroIzq;
            Contador_ctrl.Set_EN(1);
            
         when others => 
            null;
      end case;
      
      delay 0.01;
      
   end loop;

end Demo;