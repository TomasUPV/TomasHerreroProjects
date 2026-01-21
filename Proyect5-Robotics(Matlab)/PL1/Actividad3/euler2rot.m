function R = euler2rot(rX, rY, rZ)
% Convierte los angulos de Euler III (roll, pitch, yaw) expresados en radianes 
% en una matriz de rotation (3x3) 
% R -> matriz de rotación 
% rX-> giro en el eje X (roll) 
% rY-> giro en el eje Y (pitch) 
% rZ-> giro en el eje Z (yaw)

% Matriz de rotación ZYX (Yaw-Pitch-Roll)
% R = Rz * Ry * Rx

R = [cos(rY)*cos(rZ), cos(rZ)*sin(rX)*sin(rY) - cos(rX)*sin(rZ), sin(rX)*sin(rZ) + cos(rX)*cos(rZ)*sin(rY);
     cos(rY)*sin(rZ), cos(rX)*cos(rZ) + sin(rX)*sin(rY)*sin(rZ), cos(rX)*sin(rY)*sin(rZ) - cos(rZ)*sin(rX);
     -sin(rY),   cos(rY)*sin(rX),            cos(rX)*cos(rY)];
end