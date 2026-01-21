function [vector, angulo] = quat2aVect(quaternion)
% [vector, angulo] = quat2aVect(quaternion) 
% Cálculo del de vector del eje de giro y el ángulo de giro en radianes a partir del quaternión 
% quaternion -> vector de 4 elementos con el quaternion equivalente
% vector -> vector de 3 elementos con las coordenadas del vector director del giro
% angulo -> ángulo de giro en radianes

vector = [1 0 0];
angulo = 0;