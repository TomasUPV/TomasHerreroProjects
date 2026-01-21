function puntoMuneca = calcularPM (posicion, orientacion, longitudEslabon)
% puntoMuneca = calcularPM (posicion, orientacion, longitudEslabon)
% se calcula en punto de muñeca de una muñeca en línea
% posicion -> posición del extremo del robot
% orientacion -> orientación del extremo del robot
% longitudEslabon -> longitud del último eslabón

puntoMuneca=posicion-orientacion(:,3)*longitudEslabon;
