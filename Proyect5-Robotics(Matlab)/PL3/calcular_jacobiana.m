function [J,r]=calcular_jacobiana(DH,q,tipo)
    %
    % q -> vector con las posiciones de las articulaciones (siempre 6 elem)
    % tipo -> vector con el tipo de articulación
    % DH-> tabla parametros DH (n x 4)
    
    % =================================================================
    % 1. Configuración
    % =================================================================
   
    n = size(DH, 1); %identifico n, que me sirve para la dimensión de la matriz

    J = zeros(6,6); 

    
    Z = zeros(3, n + 1);
    P = zeros(3, n + 1);

    T_actual = eye(4); %matriz identidad 4x4
    
    P(:, 1) = T_actual(1:3, 4); % p_0
    Z(:, 1) = T_actual(1:3, 3); % z_0
    
    % =================================================================
    % 2. BUCLE DE CINEMÁTICA DIRECTA (para obtener P y Z)
    % =================================================================
    
    % Este bucle se ejecuta n veces dependiendo del robot, va mirando fila
    % por fila
    for i = 1:n

        %lo que hace es extraer los parámetros de la tabla de DH
        a = DH(i, 1);
        alpha = DH(i, 2);
        d = DH(i, 3);
        theta = DH(i, 4);

        %elige en función de si tiene un 0 o un 1 en esa sección de la 
        if tipo(i) == 1 % Revolución
            theta = theta + q(i);
        else % Prismática
            d = d + q(i);
        end

        % Matriz de transformación A_i (de i a i-1)
        A_i = [cos(theta), -sin(theta)*cos(alpha),  sin(theta)*sin(alpha), a*cos(theta);
               sin(theta),  cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
               0,           sin(alpha),            cos(alpha),          d;
               0,           0,                     0,                   1];
        
        % Calcular T_i (de i a 0)
        T_actual = T_actual * A_i;
        
        % Almacenar z_i y p_i (expresados en frame 0)
        Z(:, i + 1) = T_actual(1:3, 3);
        P(:, i + 1) = T_actual(1:3, 4);
    end
    
    % Posición del efector final (p_n)
    p_n = P(:, n + 1);

    % =================================================================
    % 3. BUCLE DE CÁLCULO DE LA JACOBIANA
    % =================================================================
    
    % Este bucle también se ejecuta n veces
    for i = 1:n
        % Vectores necesarios (z_{i-1} y p_{i-1})
        z_im1 = Z(:, i);
        p_im1 = P(:, i);
        
        if tipo(i) == 1 % Articulación de REVOLUCIÓN
            Jv = cross(z_im1, (p_n - p_im1));
            Jw = z_im1;
        else % Articulación PRISMÁTICA
            Jv = z_im1;
            Jw = [0; 0; 0];
        end
        
        % Ensamblar la columna i de la Jacobiana
        % J es 6x6, pero solo rellenamos las primeras n columnas
        J(:, i) = [Jv; Jw];
    end

    % 4. CÁLCULO DEL RANGO
    % El rango se calcula sobre la matriz 6x6.
    r = rank(J);

end




    %
   % DH-> tabla parametros DH
% q -> vector con las posiciones de las articulaciones 
% tipo -> vector con el tipo de articulación
% (0->prismatica;1->revolución)

% Retorno de la función:
% J-> matriz Jacobiana 6xn
% r-> rango de la matriz Jacobiana



% J-> matriz Jacobiana 6xn



% r-> rango de la matriz Jacobiana
r = rank(J)

%apuntes: relacionar las velocidades angulares con las lineales, permite
%obtener las velocidades del extremo del robot a partir de las velocidades
%de cada articulación

%