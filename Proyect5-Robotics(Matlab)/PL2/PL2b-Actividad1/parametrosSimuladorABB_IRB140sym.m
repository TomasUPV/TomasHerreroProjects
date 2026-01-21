function [robot, parametrosDH, longitudUltimoEslabon, limitesArticulaciones, dimensionesEntorno, pasosMovimiento]=parametrosSimuladorABB_IRB140
% parametrosDH -> parámetros Denavit-Hartenberg del robot ABB-IRB140
% limitesArticulaciones -> límites de cada una de las articulaciones del robot
% longitudUltimoEslabon -> longitud del último eslabón para el cálculo del punto de muñeca
% dimensionesEntorno = dimensiones del entorno de simulación
% CR_2223

robot='ABB-IRB140.mat';

% Límites de los movimientos de las articulaciones (según datasheet ABB IRB140)
% Valores en grados, convertidos a radianes
limitesArticulaciones=[-180 180;      % eje1 (base) - Axis 1
                        -90  110;     % eje2 (hombro) - Axis 2
                        -230 50;      % eje3 (codo) - Axis 3
                        -200 200;     % eje4 (muñeca 1) - Axis 4
                        -115 115;     % eje5 (muñeca 2) - Axis 5
                        -400 400]*pi/180; % eje6 (muñeca 3) - Axis 6

% Parámetros Denavit-Hartenberg del ABB IRB140
% Basados en documentación oficial y Robotics Toolbox (Peter Corke)
% Dimensiones del robot según datasheet (en mm):
% d1 = 352 mm, a1 = 70 mm, a2 = 360 mm, d4 = 380 mm, d6 = 65 mm

% Formato de la matriz: [a (mm), d (mm), alpha (rad), theta (rad)]
% NOTA: Para articulación 2 se usa (theta2 - pi/2) según convención estándar
% En esta versión, theta se pasará como parámetro a la función calcularMTsym

% Estructura: cada fila = [a, d, alpha, offset_theta]
parametrosDH = [70,   352,  -pi/2,  0;           % Articulación 1
                360,  0,    0,      -pi/2;       % Articulación 2 (offset -90°)
                0,    0,    pi/2,   0;           % Articulación 3
                0,    380,  -pi/2,  0;           % Articulación 4
                0,    0,    pi/2,   0;           % Articulación 5
                0,    65,   0,      0];          % Articulación 6

% Longitud del último eslabón para el cálculo del punto de muñeca
% Es la distancia desde la articulación 5 hasta el TCP
longitudUltimoEslabon = 65; % mm

% Dimensiones del entorno de simulación (en mm)
% El robot ABB IRB140 tiene un alcance máximo de aproximadamente 810 mm
dimensionesEntorno = 1000;

% Puntos intermedios que se calculan al realizar un movimiento
pasosMovimiento = 10;