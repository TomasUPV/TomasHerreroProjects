% Generación de una trayectoria trapezoide

function [qvect, qvelvect, qacelvect,t] = trapez( qr1, qr2, qpr, qsec, tm,textra);

% Cálculo de los instantes del tiempo dónde comienzan
% las fases de velocidad constante y deceleración,
% así cómo del instante final del movimiento.

s=qr2-qr1;
signo = sign(s);

if abs(s) > qpr*qpr/qsec
	t1=qpr/qsec;
	t2=abs(s)/qpr;
	tfin=abs(s)/qpr+qpr/qsec;
else
	t1 = sqrt(abs(s)/qsec);
	tfin = 2*t1;
	t2=0;
end;

% Inicialización de la posición y velocidad 

q=qr1;
qprim=0;
qvect=qr1;
qvelvect=0;
qacelvect=0;
t=0;


% Bucle que recorre el tiempo del instante
% inicial al instante final

for tiempo=0:tm:tfin+textra,

% Calcula la velocidad y la posición durante el período
% de aceleración
	if tiempo < t1,
		acel = signo*qsec;
		qprim=qprim+acel*tm;
		q=q+qprim*tm+0.5*acel*tm*tm;
	
% Calcula la velocidad y la posición durante el período
% de velocidad constante

	elseif (tiempo >= t1)&(tiempo < t2),
		acel = 0;
		qprim=signo*qpr;
		q=q+qprim*tm;
	
% Calcula la velocidad y la posición durante el período
% de deceleración

	elseif (tiempo >=t2)&(tiempo <tfin)
		acel = -signo*qsec;
  	   	qprim=qprim + acel*tm;
		q=q + qprim*tm+0.5*acel*tm^2;

	else
		acel=0;
		qprim=0;
		q=qr2;

%(fin del if-else) 
      
  	end


% Añade la posición y velocidad de la iteración actual
% a los vectores respectivos.

	qvect=[qvect;q];
	qvelvect=[qvelvect;qprim];
	qacelvect=[qacelvect;acel];
	t=[t;tiempo];

% (fin del bucle)

end






