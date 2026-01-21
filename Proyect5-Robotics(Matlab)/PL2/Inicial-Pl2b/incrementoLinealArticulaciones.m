function posicionesArticulaciones = incrementoLinealArticulaciones(posicionArticulacionesInicial, posicionArticulacionesFinal, pasosMovimiento)
% posicionesArticulaciones = incrementoLinealArticulaciones(posicionInicial, posicionFinal, pasos)
%   posicionInicial -> vector con la posición inicial de cada articualción
%   posicionFinal -> vector con la posición final de cada articualción
%   posicionesArticulaciones -> matriz con las posición de las articulaciones 
%       del robot para llegar de la posicionInicial a la posicionFinal.
%       Cada columna contiene los valores para cada articulación
%       Dado que se trata de un movimiento libre del extremo del robto sin seguir
%       ninguna trayectoria determinada, para ir de una posicion a la otra, se
%       discretiza en un número de pasos determinados CR_2223

        
posicionesArticulaciones = [posicionArticulacionesInicial; posicionArticulacionesFinal];
