with ada.Real_Time; use ada.Real_Time;
with uart;use uart;

package body GPIO is

   BTN: GPIO_BTN;
   for BTN'address use system.storage_elements.To_address(16#41200000#);

   RGB: GPIO_RGB;
   for RGB'address use system.storage_elements.To_address(16#41210000#);

   P8LD: GPIO_8LD;
   for P8LD'address use system.storage_elements.To_address(16#40000000#);

   SWT: GPIO_SWT;
   for SWT'address use system.storage_elements.To_address(16#40001000#);
   
   Ultra: GPIO_Ultra; 
   for Ultra'Address use System.Storage_Elements.To_Address(16#41220000#);

   Infra: GPIO_Infra; 
   for Infra'Address use System.Storage_Elements.To_Address(16#40001000#);

   -- EJERCICIO 1 SESIÓN 3: Display
   Display: Disp;
   for Display'Address use System.Storage_Elements.To_Address(16#41220000#);


   procedure Init is
   begin
      RGB.control:=0; --out
      BTN.control:=1; --in
      P8LD.control:=0; --out
      SWT.control:=16#FF#; --todo in, infrarrojos obstaculos y siguelineas
      Ultra.control := 16#0001#; --Trigger out (IO27), echo in (IO26) D = 1101. 
   end Init;



   -- sensores funcionan con lógica negada
   function leer_sensor_derecha return Boolean is
   begin

      if SWT.datos.switch1 = Off then
         return True;
      else
         return False;
      end if;
   end leer_sensor_derecha;

   function leer_sensor_izquierda return Boolean is
   begin
      if SWT.datos.switch2 = Off then
         return True;
      else
         return False;
      end if;
   end leer_sensor_izquierda;
   
   
   -- Completar 
   -- sensores funcionan con lógica negada

   function leer_ir1 return Boolean is
   begin
      if infra.datos.ir1 = Off then
         return True;
      else
         return False;
      end if;
   end leer_ir1;
   
   function leer_ir2 return Boolean is
   begin
      if infra.datos.ir2 = Off then
         return True;
      else
         return False;
      end if;
   end leer_ir2;
   
   function leer_ir3 return Boolean is
   begin
      if infra.datos.ir3 = Off then
         return True;
      else
         return False;
      end if;
   end leer_ir3;
   
   function leer_ir4 return Boolean is
   begin
      if infra.datos.ir4 = Off then
         return True;
      else
         return False;
      end if;
   end leer_ir4;
   
   function leer_ir5 return Boolean is
   begin
      if infra.datos.ir5 = Off then
         return True;
      else
         return False;
      end if;
   end leer_ir5;
   
   
   function ReadButton0 return Boolean is 
   begin 
      if BTN.datos.btn0 = On then 
         return True;
      else
         return False;
      end if;
   end ReadButton0;
   
   function ReadButton1 return Boolean is 
   begin 
      if BTN.datos.btn1 = On then 
         return True;
      else
         return False;
      end if;
   end ReadButton1;
   
   procedure EnciendeRGB (color0, color1: RGBtype) is
   begin
      RGB.datos.rgbColor0:=color0;
      RGB.datos.rgbColor1:=color1;

   end EnciendeRGB;

   procedure enviaSenyalON is
   begin
      Ultra.datos.trigger := True;
   end enviaSenyalON;


   procedure enviaSenyalOFF is
   begin
      Ultra.datos.trigger := False;
   end enviaSenyalOFF;

   -- c) Función para leer el valor del echo
   function recibeSenyal return Boolean is
   begin
      return Ultra.datos.echo;
   end recibeSenyal;
   
   protected body Datos_Sensores is
      procedure Set_Distancia (D : Float) is
      begin
         Datos_Sensores.Distancia := D;
      end Set_Distancia;
      
      procedure Set_Frontales (B1, B2 : Boolean) is
      begin
         Datos_Sensores.S_I := B1;
         Datos_Sensores.S_D := B2;
      end Set_Frontales;

      procedure Set_Infrarrojos (I : Integer) is
      begin
         Datos_Sensores.Infra := I;
      end Set_Infrarrojos;
      
      
      function Get_Distancia return Float is
      begin
         return Distancia;
      end Get_Distancia;
      
      function Get_S_I return Boolean is
      begin
         return S_I;
      end Get_S_I;
      
      function Get_S_D return Boolean is 
      begin
         return S_D;
      end Get_S_D;
      
      function Get_Infrarrojos return Integer is
      begin
         return Infra;
      end Get_Infrarrojos;
      
   end Datos_Sensores;
   

   -- EJERCICIO 2 SESIÓN 3: Implementación de objetos protegidos para Display
   protected body Datos_7SEG is
      procedure Set_Seg1 (DL: Integer) is
      begin
         Datos_7SEG.Seg1 := DL;
      end Set_Seg1;

      procedure Set_Seg2 (UN: Integer) is
      begin
         Datos_7SEG.Seg2 := UN;
      end Set_Seg2;

      function Get_Seg1 return Integer is (Seg1);
      function Get_Seg2 return Integer is (Seg2);
   end Datos_7SEG;

   protected body Contador_ctrl is
      procedure Set_EN (x: Integer) is
      begin
         Contador_ctrl.EN := x;
      end Set_EN;

      function Get_EN return Integer is (EN);
   end Contador_ctrl;


   -- EJERCICIO 2 SESIÓN 3: Procedimiento para mostrar números
   procedure MostrarNumero (numero: Integer) is
   begin
      case numero is
         when 0 => Display.D_num := D0;
         when 1 => Display.D_num := D1;
         when 2 => Display.D_num := D2;
         when 3 => Display.D_num := D3;
         when 4 => Display.D_num := D4;
         when 5 => Display.D_num := D5;
         when 6 => Display.D_num := D6;
         when 7 => Display.D_num := D7;
         when 8 => Display.D_num := D8;
         when 9 => Display.D_num := D9;
         when 11 => Display.D_num := D11;
         when others => Display.D_num := off;
      end case;
   end MostrarNumero;


   -- EJERCICIO 2 SESIÓN 3: Procedimientos de movimiento del robot
   procedure Avanza is
   begin
      MI := True;
      MD := True;
      P8LD.datos.sentidoI := adelante;
      P8LD.datos.sentidoD := adelante;
   end Avanza;

   procedure Para is
   begin
      MI := False;
      MD := False;
      P8LD.datos.sentidoI := parado;
      P8LD.datos.sentidoD := parado;
   end Para;

   procedure GiroIzq is
   begin
      MI := True;
      MD := True;
      P8LD.datos.sentidoI := atras;
      P8LD.datos.sentidoD := adelante;
   end GiroIzq;

   procedure GiroDrcha is
   begin
      MI := True;
      MD := True;
      P8LD.datos.sentidoI := adelante;
      P8LD.datos.sentidoD := atras;
   end GiroDrcha;


   task body Sensorizacion is
      period_U: constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(300); -- ultrasonidos
      t_ini, t_fin, inicio:  Ada.Real_Time.Time := Ada.Real_Time.Clock;
      duracion: Duration;
      distancia: float;
      S_I,S_D, S_IR1, S_IR2, S_IR3, S_IR4, S_IR5 : Boolean; 
      n_active: Integer;
      velocidad_sonido: constant Float := 343.0;

   begin

      bucle_ext: loop
          
          -- 1. Enviar pulso de trigger (10us de duración según especificación típica)
         enviaSenyalON;
         delay 0.00001; -- 10 microsegundos
         enviaSenyalOFF;
      
      -- 2. Esperar a que el echo se active (objeto detectado)
         t_ini := Clock;
         while recibeSenyal = False loop
         -- Esperar a que el echo pase a alto
         -- Timeout de seguridad (evitar bucle infinito si no hay eco)
            if Clock - t_ini > Milliseconds(30) then
               exit; -- Salir si pasan 30ms sin respuesta
            end if;
         end loop;
      
      -- 3. Medir el tiempo que el echo está en alto
         t_ini := Clock;
         while recibeSenyal = True loop
         -- El echo está alto, esperamos a que baje
            if Clock - t_ini > Milliseconds(30) then
               exit; -- Timeout de seguridad
            end if;
         end loop;
         t_fin := Clock;
      
      -- 4. Calcular la distancia
      -- Tiempo = duración del pulso echo en alto
         duracion := To_Duration(t_fin - t_ini);
      

         distancia := (velocidad_sonido * Float(duracion) / 2.0) * 100.0;
      
      -- 5. Guardar la distancia en el objeto protegido
         Datos_Sensores.Set_Distancia(distancia);
         
         t_fin:=Clock;
         
         --Infrarrojos frontales IRF
         S_I := leer_sensor_izquierda;
         S_D := leer_sensor_derecha;
         Datos_Sensores.Set_Frontales(S_I,S_D);
         
         --Infrarrojos inferiores IRI
         n_active := 0;
   
         S_IR1 := leer_ir1;
         S_IR2 := leer_ir2;
         S_IR3 := leer_ir3;
         S_IR4 := leer_ir4;
         S_IR5 := leer_ir5;
   
         if S_IR1 = True then n_active := n_active +1 ;end if;
         if S_IR2 = True then n_active := n_active +1;end if;
         if S_IR3 = True then n_active := n_active +1;end if;
         if S_IR4 = True then n_active := n_active +1;end if;
         if S_IR5 = True then n_active := n_active +1;end if;
   
         Datos_Sensores.Set_Infrarrojos(n_active);
 
         delay until Clock + period_U;

      end loop bucle_ext;
   end Sensorizacion;


   -- EJERCICIO 1 SESIÓN 3: Tarea PWM
   task body PWM is
      Period : constant Time_Span := Microseconds(1000);  -- 1000 microsegundos
      Duty_Cycle : constant Time_Span := Microseconds(100); -- 100 microsegundos
      Next_Time : Time;
   begin
      Next_Time := Clock;
      
      loop
         -- Fase ON del PWM
         Next_Time := Next_Time + Duty_Cycle;
         
         -- Leer el estado de las variables globales MI y MD
         P8LD.datos.pwmI := MI;
         P8LD.datos.pwmD := MD;
         
         delay until Next_Time;
         
         -- Fase OFF del PWM
         Next_Time := Next_Time + (Period - Duty_Cycle);
         
         -- Apagar los motores
         P8LD.datos.pwmI := False;
         P8LD.datos.pwmD := False;
         
         delay until Next_Time;
      end loop;
   end PWM;


   -- EJERCICIO 3 SESIÓN 3: Tarea Cuenta (Display)
   task body Cuenta is
      next, next_I :time;
      cont, EN: Integer;
      DL, UN : Integer :=0;--DL decenas, UN unidades
   begin
      next:=clock;
      loop
         next:=clock;
         EN:= Contador_ctrl.Get_EN;
         if EN = 0 then 
            cont := 0;
         elsif EN = 1 then 
            cont := cont+1;
         end if;
         
         -- en la variable cont se guarda el valor a mostrar en el display
         if cont < 100 then
            DL := cont / 10;  -- Decenas
            UN := cont mod 10; -- Unidades
         else -- Si el contador es >=100, muestro AA. Se acaba el tiempo
            DL := 11;
            UN := 11;
         end if;
         
         loop
            next_I:=clock;
            MostrarNumero(-1);--Apago display
            
            -- Selecciono el bit para imprimir decenas
            Display.Cat := True;
            -- Muestro el número de las decenas, DL
            MostrarNumero(DL);
            
            delay until next_I + milliseconds(10);
            next_I:=clock;
            MostrarNumero(-1);--Apago display
            
            -- Selecciono el bit para imprimir unidades
            Display.Cat := False;
            -- Muestro el número de las unidades, UN
            MostrarNumero(UN);
            
            delay until next_I + milliseconds(10);
            if next_I > next + milliseconds(1000) then exit;end if;
         end loop;
      end loop;
   end Cuenta;

   
end GPIO;