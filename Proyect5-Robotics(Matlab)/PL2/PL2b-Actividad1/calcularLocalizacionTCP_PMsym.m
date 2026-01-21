function [posicionTCP, orientacionTCP, posicionPM] = calcularLocalizacionTCP_PMsym(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6, longitudUltimoEslabon)
% [posicionTCP, orientacion] = calcularLocalizacionTCP(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6)
% se calcula la posición del Tool Center Point a partir de los parametros
% Denavit-Hartenberg y una posición de las articulaciones
% parametrosDH -> Matriz con los parámetros DH
% theta1, theta2, theta3, theta4, theta5, theta6 -> posiciones de cada articulación
% posicionTCP -> vector con la posición del TCP
% orientacionTCP -> matriz de rotación con la orientación del TCP
% CR_2223

[T_01, T_02, T_03, T_04, T_05, T_06] = calcularMTsym(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6);
posicionTCP = [0;
                0
                0];

%Matriz de rotación
orientacionTCP = [1 0 0;
                  0 1 0;
                  0 0 1];

posicionPM = calcularPM (posicionTCP, orientacionTCP, longitudUltimoEslabon);

