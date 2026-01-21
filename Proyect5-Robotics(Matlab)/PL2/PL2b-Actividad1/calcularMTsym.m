function [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMTsym(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6)
% [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMTsym(parametrosDH, theta1, theta2, theta3, theta4, theta5, theta6)
% Calcula la matriz de transformación desde la base hasta el extremo del robot
% parametrosDH -> Matriz con los parámetros DH [a, d, alpha, offset_theta]
% theta1, theta2, theta3, theta4, theta5, theta6 -> posición de cada articulación (radianes)
% T_01, T_02, T_03, T_04, T_05, T_06 matrices de transformación desde la base del robot hasta cada una de sus articulaciones
% CR_2223

% Vector con los valores de las articulaciones
thetas = [theta1, theta2, theta3, theta4, theta5, theta6];

% Extraer parámetros DH para cada articulación
% Formato de parametrosDH: [a, d, alpha, offset_theta]

% Articulación 1
a1 = parametrosDH(1,1);
d1 = parametrosDH(1,2);
alpha1 = parametrosDH(1,3);
offset1 = parametrosDH(1,4);
theta1_final = thetas(1) + offset1;

% Articulación 2
a2 = parametrosDH(2,1);
d2 = parametrosDH(2,2);
alpha2 = parametrosDH(2,3);
offset2 = parametrosDH(2,4);
theta2_final = thetas(2) + offset2;

% Articulación 3
a3 = parametrosDH(3,1);
d3 = parametrosDH(3,2);
alpha3 = parametrosDH(3,3);
offset3 = parametrosDH(3,4);
theta3_final = thetas(3) + offset3;

% Articulación 4
a4 = parametrosDH(4,1);
d4 = parametrosDH(4,2);
alpha4 = parametrosDH(4,3);
offset4 = parametrosDH(4,4);
theta4_final = thetas(4) + offset4;

% Articulación 5
a5 = parametrosDH(5,1);
d5 = parametrosDH(5,2);
alpha5 = parametrosDH(5,3);
offset5 = parametrosDH(5,4);
theta5_final = thetas(5) + offset5;

% Articulación 6
a6 = parametrosDH(6,1);
d6 = parametrosDH(6,2);
alpha6 = parametrosDH(6,3);
offset6 = parametrosDH(6,4);
theta6_final = thetas(6) + offset6;

% Calcular las matrices de transformación individuales usando DH_transHomogenea
T_01 = DH_transHomogenea(theta1_final, d1, a1, alpha1);

T_12 = DH_transHomogenea(theta2_final, d2, a2, alpha2);
T_02 = T_01 * T_12;

T_23 = DH_transHomogenea(theta3_final, d3, a3, alpha3);
T_03 = T_02 * T_23;

T_34 = DH_transHomogenea(theta4_final, d4, a4, alpha4);
T_04 = T_03 * T_34;

T_45 = DH_transHomogenea(theta5_final, d5, a5, alpha5);
T_05 = T_04 * T_45;

T_56 = DH_transHomogenea(theta6_final, d6, a6, alpha6);
T_06 = T_05 * T_56;

end