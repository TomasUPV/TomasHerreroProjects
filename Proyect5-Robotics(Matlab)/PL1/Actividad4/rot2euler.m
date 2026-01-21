function [rX, rY, rZ] = rot2euler(R)
% [rX, rY, rZ] = rot2euler(R)
%  Convierte una matriz de rotation (3x3) en los angulos de Euler III (roll, pitch, yaw) expresados en radianes  
% rX-> giro en el eje X
% rY-> giro en el eje Y
% rZ-> giro en el eje Z
% R -> matriz de rotación
rX = 0;
rY = 0;
rZ = 0;

