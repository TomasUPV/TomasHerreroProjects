% Encuentra el error cuadrático medio entre dos vectores.

function e2=ecuad(q1,q2)

	N=length(q1);
	e2=diag((q1-q2)'*(q1-q2))/N;
