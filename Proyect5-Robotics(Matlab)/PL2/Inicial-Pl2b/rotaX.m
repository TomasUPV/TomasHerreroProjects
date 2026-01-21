function T=rotaX(angulo)
% T = rotaX(angulo)
% Obtiene la matriz de rotación 'T' correspondiente a un giro definido por
% la variable 'angulo' respecto del eje X. 'angulo' esta medido en radianes
T=[1 0 0 0;
    0 cos(angulo) -sin(angulo) 0;
    0 sin(angulo) cos(angulo) 0
    0 0 0 1];