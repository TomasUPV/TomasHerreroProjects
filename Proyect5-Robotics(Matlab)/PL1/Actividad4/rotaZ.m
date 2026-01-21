function T=rotaZ(angulo)
% T = rotaZ(angulo)
% Obtiene la matriz de rotación 'T' correspondiente a un giro definido por
% la variable 'angulo' respecto del eje Z. 'angulo' esta medido en
% radianes

T = [cos(angulo) -sin(angulo) 0 0;
     sin(angulo) cos(angulo)  0 0;
     0           0            1 0;
     0           0            0 1];