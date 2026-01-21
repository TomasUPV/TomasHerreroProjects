% 1. --- Configuración del Entorno ---
close all
clc
clear all

entorno=1000;
% Ajusta la figura para que coincida con la Figura 3
crearEntorno(1, entorno, entorno, entorno);
xlabel('X'); ylabel('Y'); zlabel('Z');
view(135, 30); % Ángulo de vista similar a las figuras

% 2. --- Definición de Constantes ---
a = 700;
b = 800;
c = 300;
d = 500;
e = 400;

% 3. --- Transformación "Mundo" ---
% Para colocar el sistema 0 en (400, -350, 0) como pide el PDF
T_Mundo = tras(400, -350, 0);

% 4. --- Cálculo de las Matrices Absolutas (respecto a 0) ---

% T0_0: Sistema 0 en el origen (relativo a sí mismo)
T0_0 = eye(4);

% T0_1: Traslación a P1 
R0_1_rot = rotaX(pi/2)*rotaZ(-pi);
T0_1 = tras(0, c+d, a-d) * R0_1_rot;

% T0_2: Traslación a P2 
R0_2_rot = rotaZ(-pi/2);
T0_2 = tras(-b, c+d, 0) * R0_2_rot;

% T0_3: Traslación a P3
R0_3_rot = rotaX(pi/2)*rotaZ(-pi/2);
T0_3 = tras(-b, c, a)*R0_3_rot;

% T0_4: Traslación a P4 
T0_4 = tras(-b, c, a-d);

% T0_5: Traslación a P5
R0_5_rot = rotaX(-pi/2)*rotaY(-pi/2);
T0_5 = tras(0, 0, a)*R0_5_rot;




% 5. --- Dibujo de todos los Sistemas (aplicando T_Mundo) ---
% Parámetros de dibujo
tamEjes = 100;
grosor = 2;

dibujarSC(T_Mundo * T0_0, '0', tamEjes, grosor);
dibujarSC(T_Mundo * T0_1, '1', tamEjes, grosor);
dibujarSC(T_Mundo * T0_2, '2', tamEjes, grosor);
dibujarSC(T_Mundo * T0_3, '3', tamEjes, grosor);
dibujarSC(T_Mundo * T0_4, '4', tamEjes, grosor);
dibujarSC(T_Mundo * T0_5, '5', tamEjes, grosor);