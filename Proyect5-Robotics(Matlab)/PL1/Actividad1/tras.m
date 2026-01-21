function T=tras(tx, ty, tz)
% T=tras(tx, ty, tz)
% Obtiene la matriz de traslación 'T' correspondiente a un desplazamiento definido por
% las coordenadas de las variable 'tx', 'ty', 'tz' 

T = [1 0 0 tx;
     0 1 0 ty;
     0 0 1 tz;
     0 0 0 1];