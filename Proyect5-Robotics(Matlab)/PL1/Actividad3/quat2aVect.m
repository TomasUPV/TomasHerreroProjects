function [vector, angulo] = quat2aVect(quaternion)
% Cálculo del de vector del eje de giro y el ángulo de giro en radianes a partir 
% del quaternión 
% quaternion -> vector de 4 elementos con el quaternion equivalente 
% vector-> vector de 3 elementos con las coordenadas del vector director del 
% giro 
% angulo -> ángulo de giro en radianes 

    % Normalizar el quaternion por seguridad numérica
    q = quaternion / norm(quaternion);
    
    q0 = q(1);
    
    % Manejar el caso de rotación nula (q0 es 1 o -1)
    if abs(q0) > (1.0 - 1e-9)
        angulo = 0; % O 2*pi, pero 0 es más simple
        vector = [1 0 0]; % El eje es indefinido, elegimos uno (X)
    else
        % Asegurar que q0 esté en el rango [-1, 1] para acos
        q0 = min(max(q0, -1.0), 1.0);
        
        angulo = 2 * acos(q0);
        
        % s = sin(angulo / 2)
        s = sqrt(1.0 - q0*q0);
        
        vector = [q(2)/s, q(3)/s, q(4)/s];
    end
end