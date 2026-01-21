close all
clc
clear all

T_00=[1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];

entorno=1000;
% Has puesto el doble de ancho en X, lo cual es perfecto para el 8
crearEntorno(1, entorno*2, entorno, entorno)

% Dibujo una nube de puntos
% Nota: Puedes cambiar el color (aquí [1,1,0]) y si se ven los ejes (aquí 'false')
% como hablamos antes. Por ejemplo: [1, 0, 0], true
[objetoH, nubePuntos] = cargarObjeto('coche.mat', [1, 1, 0], false, 200);

% --- INICIO DE LA ANIMACIÓN (Movimiento en 8) ---
% Esta sección reemplaza tu bucle "for y = ..."

% Parámetros de la trayectoria
% Ajustados a tu 'entorno' de 1000 y 'entorno*2'
amplitud_X = 1400;  % El 8 irá de -1800 a +1800 en X
amplitud_Y = 1400;  % El 8 irá de -900 a +900 en Y (Y = A_Y/2 * sin(2t))
num_pasos = 200;   % Número de pasos para completar el 8
k_roll = 0.8;      % Factor de inclinación (qué tanto se levanta)

% Vector de tiempo (ángulo) para la parametrización
t = linspace(0, 2*pi, num_pasos);

for i = 1:num_pasos
    
    % 1. CÁLCULO DE LA POSICIÓN (X, Y, Z)
    % Ecuaciones paramétricas para un 8
    
    x = amplitud_X * sin(t(i));
    y = (amplitud_Y / 2) * sin(2 * t(i));
    z = 0; % Siempre sobre la carretera
    
    % Matriz de traslación
    T_pos = tras(x, y, z);

    % 2. CÁLCULO DE LA ORIENTACIÓN (YAW)
    % Derivadas para que el coche apunte en la dirección del movimiento
    
    dx_dt = amplitud_X * cos(t(i));
    dy_dt = amplitud_Y * cos(2 * t(i)); % Ojo: 2*t
    
    anguloYaw = atan2(dy_dt, dx_dt)+pi/2; % Rotación en Z (Yaw)
    T_yaw = rotaZ(anguloYaw);

    % 3. CÁLCULO DE LA INCLINACIÓN (ROLL)
    % Inclinación (Roll) proporcional a la posición en X (para las curvas)
    
    anguloRoll = k_roll * cos(t(i)); % Rotación en X (Roll)
    T_roll = rotaX(anguloRoll);
    
    % 4. CÁLCULO DE LA MATRIZ DE TRANSFORMACIÓN FINAL (T)
    % Orden: 1. Mover, 2. Orientar (Yaw), 3. Inclinar (Roll)
    T_final = T_pos * T_yaw * T_roll;

    % 5. ACTUALIZAR EL OBJETO EN LA GRÁFICA
    % Multiplicamos la nube de puntos original por la nueva matriz
    % (Este es el método que usabas en tu código original)
    nubePuntosT = T_final * nubePuntos;
    
    % Actualizamos el objeto con la nueva nube y la nueva pose de los ejes
    actualizarObjeto(objetoH, T_final, nubePuntosT);
    
    % Pausa para que la animación sea visible
    pause(0.01); 
end