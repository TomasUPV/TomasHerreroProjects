function T = DH_transHomogenea(theta, d, a, alpha)
% T = DH_transHomogenea(theta, d, a, alpha)
% función para la creación de las matrices de transformación a partir de
% los parámetros de Denavit-Hartenberg
% theta -> rotación en Z (radianes)
% d -> desplazamiento en Z (mm)
% a -> desplazamiento en X (mm)
% alpha -> rotación en X (radianes)
% CR_2223

% Secuencia de transformaciones DH:
% T = RotZ(theta) * TrasZ(d) * TrasX(a) * RotX(alpha)

% Precalcular valores trigonométricos
ct = cos(theta);
st = sin(theta);
ca = cos(alpha);
sa = sin(alpha);

% Matriz de transformación homogénea completa
T = [ct,  -st*ca,   st*sa,  a*ct;
     st,   ct*ca,  -ct*sa,  a*st;
      0,      sa,      ca,     d;
      0,       0,       0,     1];

end