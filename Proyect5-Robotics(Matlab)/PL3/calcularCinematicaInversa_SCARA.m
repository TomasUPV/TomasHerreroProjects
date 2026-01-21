function [ejes,alcanzable] = calcularCinematicaInversa_SCARA(parametrosDH, posicion, orientacion, funcionEvalDH)
% Función para el cálculo de la cinemática inversa
% Calculo del punto de la cinemática invesa a partir de una posición
% (x,y,z) y orientación deseada (q1 q2 q3 q4) y de los parámetros
% Denavit-Hartenberg para obtener las dimensiones de ciertos eslabones
% [ejes] = calcularCinematicaInversa(parametrosDH, posicion, orientacion)
ejes=zeros(2,4);
alcanzable = [1 1 1 1];

% para cada posicion de theta1 calculo todas las posiciones de las demas
% articulaciones
longitudEslabon2=parametrosDH(1,3);
longitudEslabon3=parametrosDH(2,3);
% ejes 1 y 2
    radio = sqrt(posicion(1)^2 + posicion(2)^2);
    cosTheta2 = (radio^2 - longitudEslabon2^2 - longitudEslabon3^2)/(2 * longitudEslabon2 * longitudEslabon3);
    senTheta2 = sqrt(1-cosTheta2^2);
    if ~isreal(senTheta2)
           disp('WARNING: el punto no es alcanzable para esta configuración (solución imaginaria)'); 
           imaginaria = 0;
           senTheta2 = real(senTheta2);
        else
           imaginaria = 1;
    end
    theta2 = atan2(senTheta2,cosTheta2);
    %theta2 = theta2 - (pi/2); %porque el ABB IRB140 tiene el cero de la articulacion 3 cuando forma 90º
    %theta2 = atan(sqrt(incPosicion(1)^2+incPosicion(2)^2)/(longitudEslabon1-incPosicion(3)));
    %theta2 = pi-theta2;
    %theta3 = cos(theta2)*(incPosicion(3)-longitudEslabon1)-cos(theta2)*sqrt(incPosicion(1)^2+incPosicion(2)^2);

    beta = atan2(posicion(2), radio);
    alfa = atan2(longitudEslabon3 * senTheta2, longitudEslabon2 + longitudEslabon3 * cosTheta2);   
    %alfa = atan2(longitudEslabon3 * sin(theta2), longitudEslabon2 + longitudEslabon3 * cos(theta2));
    theta1 = beta - alfa;

        % se expresa Pm en el 1º sistema de referencia
        p1=posicion;
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

        theta2(1) = - angulo; %porque el ABB IRB140 tiene el cero de la articulacion 3 cuando forma 90º
        theta2(2) = angulo - 2*pi/2;
        %q3(1) = pi/2 - eta;
        %q3(2) = eta - 3*pi/2;


        beta = atan2(-p1(1), p1(2));
        gamma = (acos((L2^2+r^2-L3^2)/(2*r*L2)));
        if ~isreal(gamma)
            disp('WARNING: el punto no es alcanzable para esta configuración, (solución imaginaria)'); 
            imaginaria = 0;
            %gamma = real(gamma);
        else
            imaginaria = 1;
        end
        theta1(1) = pi/2 + beta - gamma;
        theta1(2) = pi/2 + beta + gamma;
        %theta1(1) = beta - gamma;
        %theta1(2) = beta + gamma;
        %q2(1) = pi/2 - beta - gamma; %codo arriba
        %q2(2) = pi/2 - beta + gamma; %codo abajo


%EJE 3
theta3 = posicion(3)-(parametrosDH(1,2)+parametrosDH(3,2)+parametrosDH(4,2));
theta3 = theta3*pi/180; %el simulador toma las posiciones de las articulaciones en radianes, aunque sea para desplazamiento

%EJE 4
%Orientación forzada con los tres primeros ejes
[T_01, T_02, T_03, T_04, T_05, T_06] = calcularDH2MT(parametrosDH, [theta1(2) theta2(2) theta3 0 0 0], funcionEvalDH);

% La orientación que deben conseguir las tres últimas
% articulaciones es R_36
R_03 = T_03(1:3,1:3);

R_deseada = quat2rot(orientacion);

R_34 = inv(R_03) * R_deseada;

[rX, rY, rZ] = rot2euler(R_34);
theta4=rZ;

%FALTA AJUSTAR PARA QUE FUNCIONEN LAS 4 CONFIGURACIONES. HASTA LA FECHA
%SOLO FUNCIONA UNA CONFIGURACIÓN
ejes=[theta1(2) theta2(2) theta3 theta4;
    theta1(2) theta2(2) theta3 theta4;
    theta1(2) theta2(2) theta3 theta4;
    theta1(2) theta2(2) theta3 theta4];


end


