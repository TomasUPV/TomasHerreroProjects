function [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMTsym(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6)
% [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMTsym(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6)
% Calcula la matriz de transformación desde la base hasta el extremo del robot
% parametrosDH -> Matriz con los parámetros DH
% theta1, theta2, theta3, theta4, theta5, theta6 -> vector con la posición de cada articulación
% T_01, T_02, T_03, T_04, T_05, T_06 matrices de transformación desde la base del robot hasta cada una de sus articulaciones
% CR_2223

matrizDH = eval(parametrosDH);

T_01 = [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1];
 T_02 = T_01;
 T_03 = T_01;
 T_04 = T_01;
 T_05 = T_01;
 T_06 = T_01;
 