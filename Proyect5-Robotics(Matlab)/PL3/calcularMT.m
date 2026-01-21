function [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMT(parametrosDH, posicionArticulaciones)
% Calcula la matriz de transformación desde la base hasta el extremo del robot
% [T_01, T_02, T_03, T_04, T_05, T_06] = calcularMT(parametrosDH, posicion)
% parametrosDH -> Matriz con los parámetros DH
% posicionArticulaciones -> vector con la posición de cada articulación
% T_01, T_02, T_03, T_04, T_05, T_06 matrices de transformación desde la
% base del robot hasta cada una de sus articulaciones

        matrizDH = evaluarParametrosDH(parametrosDH, posicionArticulaciones);
        theta = matrizDH(:,1);
        d = matrizDH(:,2);
        a = matrizDH(:,3);
        alfa = matrizDH(:,4);
        
        % Matrices de transformación de cada elemento
        T_01 = DH_transHomogenea(theta(1), d(1), a(1), alfa(1));
        T_12 = DH_transHomogenea(theta(2), d(2), a(2), alfa(2));
        T_23 = DH_transHomogenea(theta(3), d(3), a(3), alfa(3));
        T_34 = DH_transHomogenea(theta(4), d(4), a(4), alfa(4));
        T_45 = DH_transHomogenea(theta(5), d(5), a(5), alfa(5));
        T_56 = DH_transHomogenea(theta(6), d(6), a(6), alfa(6));

        % Matrices de transformación de la base a cada elementro
        T_02 = T_01*T_12;
        T_03 = T_02*T_23;
        T_04 = T_03*T_34;
        T_05 = T_04*T_45;
        T_06 = T_05*T_56;
