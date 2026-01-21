function [rX, rY, rZ] = rot2euler(R)
% [rX, rY, rZ] = rot2euler(R)
%  Convierte una matriz de rotation (3x3) en los angulos de Euler III (roll, pitch, yaw) expresados en radianes  
% rX-> giro en el eje X
% rY-> giro en el eje Y
% rZ-> giro en el eje Z
% R -> matriz de rotación
rX = atan2(R(3,2),R(3,3));
rY = asin(-R(3,1));
rZ = atan2(R(2,1),R(1,1));

