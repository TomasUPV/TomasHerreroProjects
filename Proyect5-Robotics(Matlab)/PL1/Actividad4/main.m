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

% T0_5: Traslación pura en Z de 'a'
% P5 = (0, 0, a)
T0_5 = tras(0, 0, a);

% T0_3: Traslación en X de 'b' y en Z de 'a-d'
% P3 = (b, 0, a-d) = (800, 0, 200)
T0_3 = tras(b, 0, a-d);

% T0_4: Traslación a P4 y rotación en Z de -90º
% P4 = (b, c, a-d) = (800, 300, 200)
% R4 = rotaZ(-pi/2)
T0_4 = tras(b, c, a-d) * rotaZ(-pi/2);

% T0_2: Traslación a P2 y rotación en Z de 180º
% P2 = (b+e, c, a-d) = (1200, 300, 200)
% R2 = rotaZ(pi)
T0_2 = tras(b + e, c, a - d) * rotaZ(pi);

% T0_1: Traslación a P1 y una rotación combinada
% P1 = (b+e, 0, a-d) = (1200, 0, 200)
% Ejes de R1 vistos desde 0: X1=[0,0,1], Y1=[0,-1,0], Z1=[1,0,0]
% R1 = rotaY(-pi/2) * rotaX(pi)
R0_1_rot = rotaY(-pi/2) * rotaX(pi);
T0_1 = tras(b + e, 0, a - d) * R0_1_rot;

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