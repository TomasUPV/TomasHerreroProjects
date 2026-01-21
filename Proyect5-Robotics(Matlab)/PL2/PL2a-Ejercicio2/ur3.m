% Script para robot UR3 - Universal Robots
% Parámetros DH según especificaciones oficiales de UR

clear all
close all
grid on
hold on
daspect([1 1 1])
view(3)
axis vis3d
xlabel('X (mm)')
ylabel('Y (mm)')
zlabel('Z (mm)')
title('Robot UR3 - Cinemática Directa DH')

% Parámetros DH del UR3 (convertidos a mm)
% Valores originales en metros, convertidos a milímetros para visualización
d1 = 151.9;   % mm
d4 = 112.35;  % mm
d5 = 85.35;   % mm
d6 = 81.9;    % mm

a2 = -243.65; % mm (negativo según especificación)
a3 = -213.25; % mm (negativo según especificación)

% Variables de articulación (valores de ejemplo en grados)
q1 = 0;    % grados (Rotacional)
q2 = -90;  % grados (Rotacional)
q3 = 0;    % grados (Rotacional)
q4 = 0;    % grados (Rotacional)
q5 = 90;   % grados (Rotacional)
q6 = 0;    % grados (Rotacional)

% Dibujar sistema de coordenadas base
dibujarSC(eye(4), '0', 50, 2)

% Articulación 1: theta=q1, d=d1, a=0, alpha=90°
T01 = rotaZ(q1) * tras(0,0,d1) * tras(0,0,0) * rotaX(90);
dibujarSC(T01, '1', 50, 2)

% Articulación 2: theta=q2, d=0, a=a2, alpha=0°
T12 = rotaZ(q2) * tras(0,0,0) * tras(a2,0,0) * rotaX(0);
T02 = T01 * T12;
dibujarSC(T02, '2', 50, 2)

% Articulación 3: theta=q3, d=0, a=a3, alpha=0°
T23 = rotaZ(q3) * tras(0,0,0) * tras(a3,0,0) * rotaX(0);
T03 = T02 * T23;
dibujarSC(T03, '3', 50, 2)

% Articulación 4: theta=q4, d=d4, a=0, alpha=90°
T34 = rotaZ(q4) * tras(0,0,d4) * tras(0,0,0) * rotaX(90);
T04 = T03 * T34;
dibujarSC(T04, '4', 50, 2)

% Articulación 5: theta=q5, d=d5, a=0, alpha=-90°
T45 = rotaZ(q5) * tras(0,0,d5) * tras(0,0,0) * rotaX(-90);
T05 = T04 * T45;
dibujarSC(T05, '5', 50, 2)

% Articulación 6: theta=q6, d=d6, a=0, alpha=0°
T56 = rotaZ(q6) * tras(0,0,d6) * tras(0,0,0) * rotaX(0);
T06 = T05 * T56;
dibujarSC(T06, '6', 50, 2)

% Dibujar líneas conectando los orígenes de los sistemas de coordenadas
plot3([0 T01(1,4)], [0 T01(2,4)], [0 T01(3,4)], 'k-', 'LineWidth', 3)
plot3([T01(1,4) T02(1,4)], [T01(2,4) T02(2,4)], [T01(3,4) T02(3,4)], 'k-', 'LineWidth', 3)
plot3([T02(1,4) T03(1,4)], [T02(2,4) T03(2,4)], [T02(3,4) T03(3,4)], 'k-', 'LineWidth', 3)
plot3([T03(1,4) T04(1,4)], [T03(2,4) T04(2,4)], [T03(3,4) T04(3,4)], 'k-', 'LineWidth', 3)
plot3([T04(1,4) T05(1,4)], [T04(2,4) T05(2,4)], [T04(3,4) T05(3,4)], 'k-', 'LineWidth', 3)
plot3([T05(1,4) T06(1,4)], [T05(2,4) T06(2,4)], [T05(3,4) T06(3,4)], 'k-', 'LineWidth', 3)

% Mostrar información en consola
fprintf('===============================================\n')
fprintf('           ROBOT UR3 - CINEMÁTICA DIRECTA\n')
fprintf('===============================================\n\n')

fprintf('Variables de articulación:\n')
fprintf('  q1 = %.2f° (Rotacional - Base)\n', q1)
fprintf('  q2 = %.2f° (Rotacional - Hombro)\n', q2)
fprintf('  q3 = %.2f° (Rotacional - Codo)\n', q3)
fprintf('  q4 = %.2f° (Rotacional - Muñeca 1)\n', q4)
fprintf('  q5 = %.2f° (Rotacional - Muñeca 2)\n', q5)
fprintf('  q6 = %.2f° (Rotacional - Muñeca 3)\n', q6)

fprintf('\nPosición del efector final (TCP):\n')
fprintf('  X = %.2f mm\n', T06(1,4))
fprintf('  Y = %.2f mm\n', T06(2,4))
fprintf('  Z = %.2f mm\n', T06(3,4))

fprintf('\nMatriz de transformación homogénea T06:\n')
disp(T06)

fprintf('===============================================\n')

% Ajustar vista para mejor visualización
rotate3d on