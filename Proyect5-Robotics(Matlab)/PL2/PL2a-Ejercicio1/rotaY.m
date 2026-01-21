function T=rotaY(angulo)
% T = rotaY(angulo)
% Obtiene la matriz de rotación 'T' correspondiente a un giro definido por
% la variable 'angulo' respecto del eje Y. 'angulo' esta medido en radianes

T=[cosd(angulo) 0 sind(angulo)    0;
    0           1       0       0;
   -sind(angulo) 0 cosd(angulo)   0;
    0           0       0       1];