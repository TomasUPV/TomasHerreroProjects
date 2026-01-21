clear all
close all
grid on
hold on
daspect([1 1 1])

% Ángulos en grados, distancias en mm
q1=45;
q2=0;
q3=0;

dibujarSC(eye(4),'0',50,1)
% Movimientos realizados de una fila de la tabla de parámetros
T01=rotaZ(q1)*tras(0,0,100)*tras(50,0,0)*rotaX(0); 
dibujarSC(T01,'1',50,1)
T12=rotaZ(0)*tras(0,0,q2)*tras(150,0,0)*rotaX(0);
T02 = T01*T12;
dibujarSC(T02,'2',50,1)
