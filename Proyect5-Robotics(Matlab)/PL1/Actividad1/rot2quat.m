function q = rot2quat(R)
% q = rot2quat(R)
%  Convierte una matriz de rotation (3x3) en el quaternión correspondiente
% rX-> giro en el eje X
% rY-> giro en el eje Y
% rZ-> giro en el eje Z
% R -> matriz de rotación


r11=R(1,1);
r12=R(1,2);
r13=R(1,3);
r21=R(2,1);
r22=R(2,2);
r23=R(2,3);
r31=R(3,1);
r32=R(3,2);
r33=R(3,3);

q0 = ( r11 + r22 + r33 + 1.0) / 4.0;
q1 = ( r11 - r22 - r33 + 1.0) / 4.0;
q2 = (-r11 + r22 - r33 + 1.0) / 4.0;
q3 = (-r11 - r22 + r33 + 1.0) / 4.0;
if(q0 < 0.0) 
    q0 = 0.0;
end

if(q1 < 0.0) 
    q1 = 0.0;
end
    
if(q2 < 0.0) 
    q2 = 0.0;
end
    
if(q3 < 0.0) 
    q3 = 0.0;
end
    
q0 = sqrt(q0);
q1 = sqrt(q1);
q2 = sqrt(q2);
q3 = sqrt(q3);

if(q0 >= q1 && q0 >= q2 && q0 >= q3)
    q0 = q0 * 1.0;
    q1 = q1 * signo(r32 - r23);
    q2 = q2 * signo(r13 - r31);
    q3 = q3 * signo(r21 - r12);
elseif(q1 >= q0 && q1 >= q2 && q1 >= q3)
    q0 = q0 * signo(r32 - r23);
    q1 = q1 * 1.0;
    q2 = q2 * signo(r21 + r12);
    q3 = q3 * signo(r13 + r31);
elseif(q2 >= q0 && q2 >= q1 && q2 >= q3)
    q0 = q0 * signo(r13 - r31);
    q1 = q1 * signo(r21 + r12);
    q2 = q2 * +1.0;
    q3 = q3 * sign(r32 + r23);
elseif(q3 >= q0 && q3 >= q1 && q3 >= q2)
    q0 = q0 * signo(r21 - r12);
    q1 = q1 * signo(r31 + r13);
    q2 = q2 * signo(r32 + r23);
    q3 = q3 * +1.0;
else 
    disp('coding error\n');
end
    
r = sqrt(q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3);
q0 = q0 / r;
q1 = q1 / r;
q2 = q2 / r;
q3 = q3 / r;

q=[q0 q1 q2 q3];
