function [ejes,alcanzable] = calcularCinematicaInversa_ABB(parametrosDH, posicion, orientacion, funcionEvalDH)
% Función para el cálculo de la cinemática inversa
% Calculo del punto de la cinemática invesa a partir de una posición
% (x,y,z) y orientación deseada (q1 q2 q3 q4) y de los parámetros
% Denavit-Hartenberg para obtener las dimensiones de ciertos eslabones
% [ejes] = calcularCinematicaInversa(parametrosDH, posicion, orientacion)
ejes=zeros(4,6);
alcanzable = [1 1 1 1];
% matriz de rotación que expresa la orientación deseada
R_06deseada = quat2rot(orientacion);
% calculo del punto de muñeca
% las dimensiones del 6 eslabón están el parametro (6,2) de la matriz de
% denavit-Hartenberg
%puntoMuneca=posicion-R_06deseada(:,3)*parametrosDH(6,2);
puntoMuneca = calcularPM (posicion, R_06deseada(1:3,1:3), parametrosDH(6,2));
% cálculo angulo 1ª articulación
%theta1 = atan(pm(2)/pm(1));
theta1(1) = atan2(puntoMuneca(2), puntoMuneca(1));
theta1(2) = pi+theta1(1);

% para cada posicion de theta1 calculo todas las posiciones de las demas
% articulaciones
longitudEslabon2=parametrosDH(2,3);
longitudEslabon3=parametrosDH(4,2);
for i=1:2
    % calculo de la posicion del sistema de coordendas 1 después de mover la
    % primera articulacion. Se calcula para todas las articulaciones pero solo
    % interesa la primera T_01
    [T_01, T_02, T_03, T_04, T_05, T_06] = calcularDH2MT(parametrosDH, [theta1(i) 0 0 0 0 0], funcionEvalDH);
    posicionSC1=T_01(1:3,4);

    incPosicion = puntoMuneca - posicionSC1;

    distancia = sqrt(incPosicion(1)^2 + incPosicion(2)^2 + incPosicion(3)^2);
    radio = sqrt(incPosicion(1)^2 + incPosicion(2)^2);
    cosTheta3 = (distancia^2 - longitudEslabon2^2 - longitudEslabon3^2)/(2 * longitudEslabon2 * longitudEslabon3);
    senTheta3 = sqrt(1-cosTheta3^2);
    if ~isreal(senTheta3)
           disp('WARNING: el punto no es alcanzable para esta configuración (solución imaginaria)'); 
           imaginaria = 0;
           senTheta3 = real(senTheta3);
        else
            imaginaria = 1;
    end
    theta3 = atan2(senTheta3,cosTheta3);
    theta3 = theta3 - (pi/2); %porque el ABB IRB140 tiene el cero de la articulacion 3 cuando forma 90º
    %theta2 = atan(sqrt(incPosicion(1)^2+incPosicion(2)^2)/(longitudEslabon1-incPosicion(3)));
    %theta2 = pi-theta2;
    %theta3 = cos(theta2)*(incPosicion(3)-longitudEslabon1)-cos(theta2)*sqrt(incPosicion(1)^2+incPosicion(2)^2);

    beta = atan2(incPosicion(3), radio);
    %alfa = atan2(longitudEslabon3 * senTheta3, longitudEslabon2 + longitudEslabon3 * cosTheta3);   
    alfa = atan2(longitudEslabon3 * sin(theta3), longitudEslabon2 + longitudEslabon3 * cos(theta3));
    theta2 = beta - alfa;

        % se expresa Pm en el 1º sistema de referencia
        p1 = inv(T_01)*[puntoMuneca; 1];
        r = sqrt(p1(1)^2 + p1(2)^2);
        L2=longitudEslabon2;
        L3=longitudEslabon3;
        angulo = (acos((L2^2 + L3^2 - r^2)/(2*L2*L3)));
        if ~isreal(angulo)
           disp('WARNING: el punto no es alcanzable para esta configuración (solución imaginaria)'); 
           imaginaria = 0;
           %eta = real(eta);
        else
            imaginaria = 1;
        end

        theta3(1) = (pi/2) - angulo; %porque el ABB IRB140 tiene el cero de la articulacion 3 cuando forma 90º
        theta3(2) = angulo - 3*pi/2;
        %q3(1) = pi/2 - eta;
        %q3(2) = eta - 3*pi/2;


        beta = atan2(-p1(2), p1(1));
        gamma = (acos((L2^2+r^2-L3^2)/(2*r*L2)));
        if ~isreal(gamma)
            disp('WARNING: el punto no es alcanzable para esta configuración, (solución imaginaria)'); 
            imaginaria = 0;
            %gamma = real(gamma);
        else
            imaginaria = 1;
        end
        theta2(1) = pi/2 - beta - gamma;
        theta2(2) = pi/2 - beta + gamma;
        %q2(1) = pi/2 - beta - gamma; %codo arriba
        %q2(2) = pi/2 - beta + gamma; %codo abajo

        resultado=[theta1(i) theta2(1) theta3(1);
            theta1(i) theta2(2) theta3(2)];
        indice = (i-1)*2+1;
        ejes(indice:indice+1,1:3)=resultado;
        alcanzable(indice:indice+1)=[imaginaria imaginaria];
end

%cuando se tienen las posciones de las tres primeras articulaciones se
%calcula la orientación para cada una de ellas
for i=1:2
    theta1=ejes(i,1);
    theta2=ejes(i,2);
    theta3=ejes(i,3);
        % Para el cálculo de las tres ultimas articulaciones que dan la orientación es necesario saber
        % primero que orientación se obtiene con las tres primeras
        % articulaciones. En este caso solo interesa T_03
        [T_01, T_02, T_03, T_04, T_05, T_06] = calcularDH2MT(parametrosDH, [theta1 theta2 theta3 0 0 0], funcionEvalDH);
    
        % La orientación que deben conseguir las tres últimas
        % articulaciones es R_36
        R_03 = T_03(1:3,1:3);
        R_36 = inv(R_03) * R_06deseada;
        
        
    theta4 = atan2(R_36(2,3),R_36(1,3));
    theta5 = -acos(R_36(3,3));
    theta6 = atan2(R_36(3,2),-R_36(3,1));
    
    theta5=real(theta5);
    
    ejes(i,4:6) = [theta4, theta5, theta6];
end

end