function [robot, parametrosDH, longitudUltimoEslabon, limitesArticulaciones, tiposArticulaciones, dimensionesEntorno, pasosMovimiento, funcionEvalDH, funcionCinInv]=parametrosSimuladorSCARAfun

robot='KUKA_KR10_scara.mat';


% límites de los movimientos de las articulaciones
limitesArticulaciones=[-160 160;      % eje1
                        -110 110;        % eje2
                        -270 0;        % eje3
                        -266 266;       % eje4
                        0 0;       % eje5
                        0 0]*pi/180; % eje6

% 0->Prismática 1->Revolución  
tiposArticulaciones=[1;
                     1;
                     0;
                     1];
                                      
% parámetros Denavit-Hartenberg

parametrosDH =[0    460      260      0;
                0     0        350      0;
                0     -70    0       0;
                0     -40   	 0       0];

% longitud del último eslabón para el cálculo del punto de muñeca
longitudUltimoEslabon = 200;

% dimensiones del entorno de simulación
dimensionesEntorno=1000;

% funcion que evalua los parametros DH para una posicion determinada
funcionEvalDH = @evaluarParametrosDH_SCARA;

% función que calcula la cinemática inversa
funcionCinInv = @calcularCinematicaInversa_SCARA;


% puntos intermedios que se calculan al realizan un movimiento
pasosMovimiento = 10;
