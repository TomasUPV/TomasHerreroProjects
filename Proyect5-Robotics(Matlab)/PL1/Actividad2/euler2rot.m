function R = euler2rot(rX, rY, rZ)
% R = euler2rot(rX, rY, rZ)
%  Convierte los angulos de Euler III (roll, pitch, yaw) expresados en radianes en una matriz de rotation (3x3)
% R -> matriz de rotación
% rX-> giro en el eje X
% rY-> giro en el eje Y
% rZ-> giro en el eje Z

R = [1 0 0;
    0 1 0;
    0 0 1];