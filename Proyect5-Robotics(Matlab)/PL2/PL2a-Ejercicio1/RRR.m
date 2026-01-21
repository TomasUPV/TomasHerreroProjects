% Script para robot RRR (Rotacional-Rotacional-Rotacional)
% Parámetros: a=400, b=100, c=300, d=200

clear all
close all
grid on
hold on
daspect([1 1 1])
xlabel('X (mm)')
ylabel('Y (mm)')
zlabel('Z (mm)')
title('Robot RRR - Cinemática Directa DH')

% Parámetros del robot (en mm)
a = 400;
b = 100;
c = 300;
d = 200;

% Variables de articulación (valores de ejemplo)
q1 = 0;  % grados (Rotacional)
q2 = 0;  % grados (Rotacional)
q3 = 0; % grados (Rotacional)

% Dibujar sistema de coordenadas base
dibujarSC(eye(4), '0', 80, 2)

% Articulación 1: R (theta=q1, d=a, a=b, alpha=90°)
T01 = rotaZ(q1) * tras(a,0,0) * tras(0,0,0) * rotaX(-90);
dibujarSC(T01, '1', 80, 2)

% Articulación 2: R (theta=q2, d=c, a=0, alpha=0°)
T12 = rotaZ(q2-90) * tras(0,0,0) * tras(b,0,0) * rotaX(0);
T02 = T01 * T12;
dibujarSC(T02, '2', 80, 2)

% Articulación 3: R (theta=q3, d=0, a=d, alpha=0°)
T23 = rotaZ(q3) * tras(0,0,0) * tras(c,0,0) * rotaX(0);
T03 = T02 * T23;
dibujarSC(T03, '3', 80, 2)

% Dibujar líneas conectando los orígenes de los sistemas de coordenadas
plot3([0 T01(1,4)], [0 T01(2,4)], [0 T01(3,4)], 'k-', 'LineWidth', 2)
plot3([T01(1,4) T02(1,4)], [T01(2,4) T02(2,4)], [T01(3,4) T02(3,4)], 'k-', 'LineWidth', 2)
plot3([T02(1,4) T03(1,4)], [T02(2,4) T03(2,4)], [T02(3,4) T03(3,4)], 'k-', 'LineWidth', 2)

% Mostrar información
fprintf('=== Robot RRR ===\n')
fprintf('q1 = %.2f° (Rotacional)\n', q1)
fprintf('q2 = %.2f° (Rotacional)\n', q2)
fprintf('q3 = %.2f° (Rotacional)\n', q3)
fprintf('\nPosición del efector final:\n')
fprintf('X = %.2f mm\n', T03(1,4))
fprintf('Y = %.2f mm\n', T03(2,4))
fprintf('Z = %.2f mm\n', T03(3,4))