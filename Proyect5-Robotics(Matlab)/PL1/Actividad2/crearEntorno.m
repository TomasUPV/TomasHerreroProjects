function crearEntorno(figura, amplitudX, amplitudY, amplitudZ)
%function crearEntorno(figura, amplitudX, amplitudY, amplitudZ)

% Entorno 3D
figure(figura)          
grid on
hold on
daspect([1 1 1])   % fijado el ratio del aspecto
view(135,25)
xlabel('X'),ylabel('Y'),zlabel('Z');
title('Práctica Geometría Sistemas Robotizados');
axis([-amplitudX amplitudX -amplitudY amplitudY -amplitudZ/4 amplitudZ]);

% Dibujo del plano del suelo
x = -amplitudX:amplitudX/2:amplitudX;
y = -amplitudY:amplitudY/2:amplitudY;
[x, y] = meshgrid(x,y);
z = zeros(size(x));
surf(x,y,z,'facealpha',0.1,'linestyle',':')
