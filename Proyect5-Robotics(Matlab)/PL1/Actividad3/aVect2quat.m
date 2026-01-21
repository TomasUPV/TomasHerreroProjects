function quaternion = aVect2quat(vector, angulo)
% Cálculo del quaternión a parti de vector del eje de giro y el ángulo de giro en [cite: 145]
% radianes [cite: 145]
% quaternion -> vector de 4 elementos con el quaternion equivalente [cite: 149]
% vector -> vector de 3 elementos con las coordenadas del vector director del [cite: 147]
% giro [cite: 147]
% angulo -> ángulo de giro [cite: 148]

    % Asegurar que el vector es unitario
    v_norm = norm(vector);
    if v_norm < 1e-9
        % Si el vector es (0,0,0), es una rotación nula
        quaternion = [1 0 0 0];
        return;
    end
    v = vector / v_norm;
    
    % Fórmulas de conversión
    q0 = cos(angulo / 2);
    s = sin(angulo / 2);
    
    q1 = v(1) * s;
    q2 = v(2) * s;
    q3 = v(3) * s;
    
    quaternion = [q0 q1 q2 q3];
end