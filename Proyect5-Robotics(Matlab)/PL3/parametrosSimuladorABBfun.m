function [robot, parametrosDH, longitudUltimoEslabon, limitesArticulaciones, tiposArticulaciones, dimensionesEntorno, pasosMovimiento, funcionEvalDH, funcionCinInv]=parametrosSimuladorABBfun

robot='ABB-IRB140.mat';


% límites de los movimientos de las articulaciones
limitesArticulaciones=[-180 180;      % eje1
                        -90 110;        % eje2
                        -230 50;        % eje3
                        -200 200;       % eje4
                        -115 115;       % eje5
                        -400 400]*pi/180; % eje6

% 0->Prismática 1->Revolución  
tiposArticulaciones=[1;
                     1;
                     1;
                     1;
                     1;
                     1];
                 
% parámetros Denavit-Hartenberg
parametrosDH = [0       352     70     -pi/2;
                -pi/2   0       360     0;
                0       0       0       -pi/2;
                0       380     0       pi/2;
                0       0       0       -pi/2;
                0       65      0       0];
            
      

% dimensiones del entorno de simulación
dimensionesEntorno=1000;

% dimensiones del último eslabón
longitudUltimoEslabon = 65;

% funcion que evalua los parametros DH para una posicion determinada
funcionEvalDH = @evaluarParametrosDH_ABB;

% función que calcula la cinemática inversa
funcionCinInv = @calcularCinematicaInversa_ABB;

% puntos intermedios que se calculan al realizan un movimiento
pasosMovimiento = 10;
