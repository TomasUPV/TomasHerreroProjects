function matrizDH = evaluarParametrosDH_SCARA(parametrosDH, posicion)

matrizDH = parametrosDH;

matrizDH(1,1) = matrizDH(1,1) + posicion(1);
matrizDH(2,1) = matrizDH(2,1) + posicion(2);
matrizDH(3,2) = matrizDH(3,2) + posicion(3)*180/pi; %tener la precaución de que los valores que llegan del scroll estan en grados
matrizDH(4,1) = matrizDH(4,1) + posicion(4);
%matrizDH(5,1) = matrizDH(5,1) + posicion(5);
%matrizDH(6,1) = matrizDH(6,1) + posicion(6);

