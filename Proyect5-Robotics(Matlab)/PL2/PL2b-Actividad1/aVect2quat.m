function quaternion = aVect2quat(vector, angulo)
% quaternion = aVect2quat(vector, angulo) 
% Cálculo del quaternión a parti de vector del eje de giro y el ángulo de giro en radianes
% quaternion = aVect2quat(vector, angulo)
% vector -> vector de 3 elementos con las coordenadas del vector director del giro
% angulo -> ángulo de giro
% quaternion -> vector de 4 elementos con el quaternion equivalente

vector = vector/norm(vector);

quaternion = [cos(angulo/2) vector*sin(angulo/2)];

