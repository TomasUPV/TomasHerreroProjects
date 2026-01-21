function [posicionTCP, orientacionTCP, posicionPM] = calcularTCP_PM(parametrosDH, posicion, longitudUltimoEslabon, tiposArticulaciones)
% [posicionTCP, orientacion] = calcularLocalizacionTCP(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6)
% se calcula la posición del Tool Center Point a partir de los parametros
% Denavit-Hartenberg y una posición de las articulaciones
% parametrosDH -> Matriz con los parámetros DH
% theta1, theta2, theta3, theta4, theta5, theta6 -> posiciones de cada articulación
% posicionTCP -> vector con la posición del TCP
% orientacionTCP -> matriz de rotación con la orientación del TCP

[T_01, T_02, T_03, T_04, T_05, T_06] = calcularDH2MT(parametrosDH, posicion, tiposArticulaciones);
posicionTCP = T_06(1:3,4);

%Matriz de rotación
orientacionTCP = T_06(1:3,1:3);

posicionPM = calcularPM (posicionTCP, orientacionTCP, longitudUltimoEslabon);

