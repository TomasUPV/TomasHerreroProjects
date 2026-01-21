function [rX, rY, rZ] = rot2euler(R)
% Convierte una matriz de rotation (3x3) en los angulos de Euler III (roll,pitch, yaw) expresados en radianes 
% rX-> giro en el eje X 
% rY-> giro en el eje Y 
% rZ-> giro en el eje Z 
% R -> matriz de rotación 

    % Extraer el seno de rY de la matriz
    sy = -R(3,1);

    % Comprobar si hay bloqueo de cardán
    % Si cos(rY) es cercano a 0, sy es cercano a +/- 1
    if abs(sy) > (1.0 - 1e-6)  % Estamos en bloqueo de cardán
        
        rX = atan2(-R(2,3), R(2,2));
       
        rY = atan2(sy, 0); % Esto dará +/- pi/2

        % Forzamos rZ = 0 
        rZ = 0;
    else
        % Caso normal (sin bloqueo)
        cy = sqrt(1 - sy*sy); % O sqrt(R(1,1)^2 + R(2,1)^2)
      
        rX = atan2(R(3,2) / cy, R(3,3) / cy);
        rY = atan2(sy, cy);
        rZ = atan2(R(2,1) / cy, R(1,1) / cy);
    end
end