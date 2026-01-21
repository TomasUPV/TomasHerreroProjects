function [robot, parametrosDH, longitudUltimoEslabon, limitesArticulaciones, dimensionesEntorno, pasosMovimiento]=parametrosSimuladorABB_IRB140
% parametrosDH -> parámetros Denavit-Hartenberg del robot ABB-IRB140
% limitesArticulaciones -> límites de cada una de las articulaciones del robot
% longitudUltimoEslabon -> longitud del último eslabón para el cálculo del punto de muñeca
% dimensionesEntorno = dimensiones del entorno de simulación
% CR_2223

robot='ABB-IRB140.mat';


% límites de los movimientos de las articulaciones
limitesArticulaciones=[-0 0;          % eje1
                        -0 0;         % eje2
                        -0 0;         % eje3
                        -0 0;         % eje4
                        -0 0;         % eje5
                        -0 0]*pi/180; % eje6

% parámetros Denavit-Hartenberg
% theta_i representa la posición de cada articulación
syms theta1 theta2 theta3 theta4 theta5 theta6 parametrosDH;            

parametrosDH = [0 0 0 theta1;
                0 0 0 theta2;
                0 0 0 theta3;
                0 0 0 theta4;
                0 0 0 theta5;
                0 0 0 theta6];

% longitud del último eslabón para el cálculo del punto de muñeca
longitudUltimoEslabon = 0;


% dimensiones del entorno de simulación
dimensionesEntorno=1000;


% puntos intermedios que se calculan al realizan un movimiento
pasosMovimiento = 10;
