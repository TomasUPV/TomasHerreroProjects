function varargout = calcularDH2MT(parametrosDH, posicionArticulaciones, tipoArticulaciones)
% Calcula la matriz de transformación desde la base hasta el extremo del robot
% [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMT(parametrosDH, posicion)
% parametrosDH -> Matriz con los parámetros DH
% posicionArticulaciones -> vector con la posición de cada articulación
% T_01, T_02, T_03, T_04, T_05, T_06 matrices de transformación desde la
% base del robot hasta cada una de sus articulaciones

numeroEjes = size(parametrosDH, 1);

varargout=cell(numeroEjes,1);

T=eye(4);

theta = parametrosDH(:,1);
d = parametrosDH(:,2);
a = parametrosDH(:,3);
alfa = parametrosDH(:,4);
  
for i=1:numeroEjes
    if (tipoArticulaciones(i)==1)
        thetai=theta(i)+posicionArticulaciones(i);
        di=d(i);
    else
        thetai=theta(i);
        di=d(i)+posicionArticulaciones(i);
    end
    T=T*DH_transHomogenea(thetai,di,a(i),alfa(i));
    varargout{i}=T;
end

if numeroEjes<6
    for i=numeroEjes+1:6
        varargout{i}=varargout{numeroEjes};
    end
end