function [vector, angulo] = quat2aVect(quaternion)
% [vector, angulo] = quat2aVect(quaternion) 
% Cálculo del de vector del eje de giro y el ángulo de giro en radianes a partir del quaternión 
% quaternion -> vector de 4 elementos con el quaternion equivalente
% vector -> vector de 3 elementos con las coordenadas del vector director del giro
% angulo -> ángulo de giro en radianes

anguloMedios = acos(quaternion(1));

angulo = 2 * anguloMedios;

denominador = sin(anguloMedios);

if denominador == 0
    denominador = 0.000000000001;
end
    
vector = quaternion(2:4)/denominador;

if norm(vector) == 0
    vector=[1 0 0];
end


