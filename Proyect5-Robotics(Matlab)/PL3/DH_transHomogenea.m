function T = DH_transHomogenea(theta, d, a, alpha)
% función para la creación de las matrices de transformación a partir de
% los parámetros de Denavit-Hartenberg
% T = DH_transHomogenea(theta, d, a, alpha)
     
        T = [cos(theta)  -cos(alpha)*sin(theta)   sin(alpha)*sin(theta)   a*cos(theta);
            sin(theta)   cos(alpha)*cos(theta)  -sin(alpha)*cos(theta)   a*sin(theta);
            0              sin(alpha)             cos(alpha)             d;
            0                     0                     0              1];
end
