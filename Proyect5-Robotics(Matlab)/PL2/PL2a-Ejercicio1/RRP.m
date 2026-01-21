% Script para robot RRP (Rotacional-Rotacional-Prismática)
% Parámetros: a=400, b=100, c=300, d=200

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
title('Robot RRP - Cinemática Directa DH')

% Parámetros del robot (en mm)
a = 400;
b = 100;
c = 300;
d = 200;

% Variables de articulación (valores de ejemplo)
q1 = 30;  % grados (Rotacional)
q2 = 60;  % grados (Rotacional)
q3 = 180; % mm (Prismática)

% Dibujar sistema de coordenadas base
dibujarSC(eye(4), '0', 80, 2)

% Articulación 1: R (theta=q1, d=a, a=b, alpha=90°)
T01 = rotaZ(q1) * tras(0,0,a) * tras(0,0,0) * rotaX(-90);
dibujarSC(T01, '1', 80, 2)

% Articulación 2: R (theta=q2, d=c, a=d, alpha=0°)
T12 = rotaZ(q2+90) * tras(0,0,c) * tras(b,0,0) * rotaX(-90);
T02 = T01 * T12;
dibujarSC(T02, '2', 80, 2)

% Articulación 3: P (theta=0°, d=q3, a=0, alpha=0°)
T23 = rotaZ(0) * tras(0,0,300+q3) * tras(0,0,0) * rotaX(0);
T03 = T02 * T23;
dibujarSC(T03, '3', 80, 2)

% Dibujar líneas conectando los orígenes de los sistemas de coordenadas
plot3([0 T01(1,4)], [0 T01(2,4)], [0 T01(3,4)], 'k-', 'LineWidth', 2)
plot3([T01(1,4) T02(1,4)], [T01(2,4) T02(2,4)], [T01(3,4) T02(3,4)], 'k-', 'LineWidth', 2)
plot3([T02(1,4) T03(1,4)], [T02(2,4) T03(2,4)], [T02(3,4) T03(3,4)], 'k-', 'LineWidth', 2)

% Mostrar información
fprintf('=== Robot RRP ===\n')
fprintf('q1 = %.2f° (Rotacional)\n', q1)
fprintf('q2 = %.2f° (Rotacional)\n', q2)
fprintf('q3 = %.2f mm (Prismática)\n', q3)
fprintf('\nPosición del efector final:\n')
fprintf('X = %.2f mm\n', T03(1,4))
fprintf('Y = %.2f mm\n', T03(2,4))
fprintf('Z = %.2f mm\n', T03(3,4))