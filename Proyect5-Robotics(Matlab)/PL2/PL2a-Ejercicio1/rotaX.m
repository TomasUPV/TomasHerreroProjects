function T=rotaX(angulo)
% T = rotaX(angulo)
% Obtiene la matriz de rotación 'T' correspondiente a un giro definido por
% la variable 'angulo' respecto del eje X. 'angulo' esta medido en radianes
T=[1 0 0 0;
    0 cosd(angulo) -sind(angulo) 0;
    0 sind(angulo) cosd(angulo) 0
    0 0 0 1];