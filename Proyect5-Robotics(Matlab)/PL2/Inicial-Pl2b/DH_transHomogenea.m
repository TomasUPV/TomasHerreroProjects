function T = DH_transHomogenea(theta, d, a, alpha)
% T = DH_transHomogenea(theta, d, a, alpha)
% función para la creación de las matrices de transformación a partir de
% los parámetros de Denavit-Hartenberg
% theta -> rotación en Z
% d -> desplazamiento en Z
% a -> desplazamiento en X
% alpha -> rotación en X
% CR_2223
     
T = [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1];

end
