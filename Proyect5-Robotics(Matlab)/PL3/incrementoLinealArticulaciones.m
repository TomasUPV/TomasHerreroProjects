function posicionesArticulaciones = incrementoLinealArticulaciones(posicionArticulacionesInicial, posicionArticulacionesFinal, pasosMovimiento)
% posicionesArticulaciones = incrementoLinealArticulaciones(posicionInicial, posicionFinal, pasos)
%   posicionInicial -> vector con la posición inicial de cada articualción
%   posicionFinal -> vector con la posición final de cada articualción
%   posicionesArticulaciones -> matriz con las posición de las articulaciones 
%       del robot para llegar de la posicionInicial a la posicionFinal.
%       Cada columna contiene los valores para cada articulación
%       Dado que se trata de un movimiento libre del extremo del robto sin seguir
%       ninguna trayectoria determinada, para ir de una posicion a la otra, se
%       discretiza en un número de pasos determinados
articulacion2 = zeros(pasosMovimiento,1);
articulacion3 = zeros(pasosMovimiento,1);
articulacion4 = zeros(pasosMovimiento,1);
articulacion5 = zeros(pasosMovimiento,1);
articulacion6 = zeros(pasosMovimiento,1);
numeroEjes = size(posicionArticulacionesFinal, 2);
        
articulacion1 = linspace(posicionArticulacionesInicial(1),posicionArticulacionesFinal(1),pasosMovimiento)';
if numeroEjes>=2
    articulacion2 = linspace(posicionArticulacionesInicial(2),posicionArticulacionesFinal(2),pasosMovimiento)';
    if numeroEjes>=3
        articulacion3 = linspace(posicionArticulacionesInicial(3),posicionArticulacionesFinal(3),pasosMovimiento)';
        if numeroEjes>=4
            articulacion4 = linspace(posicionArticulacionesInicial(4),posicionArticulacionesFinal(4),pasosMovimiento)';
            if numeroEjes>=5
                articulacion5 = linspace(posicionArticulacionesInicial(5),posicionArticulacionesFinal(5),pasosMovimiento)';
                if numeroEjes>=6
                    articulacion6 = linspace(posicionArticulacionesInicial(6),posicionArticulacionesFinal(6),pasosMovimiento)';
                end
            end
        end
    end
end

posicionesArticulaciones = [articulacion1 articulacion2 articulacion3 articulacion4 articulacion5 articulacion6];
