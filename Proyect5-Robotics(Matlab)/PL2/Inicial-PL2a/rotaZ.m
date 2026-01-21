function T=rotaZ(angulo)
% T = rotaZ(angulo)
% Obtiene la matriz de rotación 'T' correspondiente a un giro definido por
% la variable 'angulo' respecto del eje Z. 'angulo' esta medido en
% radianes

T=[cosd(angulo) -sind(angulo)  0   0;
   sind(angulo) cosd(angulo)   0   0;
   0           0             1   0;
   0           0             0   1];