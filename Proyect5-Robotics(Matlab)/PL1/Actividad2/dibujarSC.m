function [ejeX_H, ejeY_H, ejeZ_H, textoX_H, textoY_H, textoZ_H] = dibujarSC(matrizTransformacion, etiqueta, tamanyoEjes, grosorLinea)
% dibujarSC(matrizTransformacion, etiqueta, tamanyoEjes, grosorLinea)
%
% dibuja un sistema de coordenadas con la localización (posición y
% orientación) definida por la variable 'matrizTransformacion'
%
% etiqueta -> nombre que aparece en los subindices de los ejes
% tamanyoEjes -> longitud de los ejes del sistema de coordenadas
% grosorLinea -> grosor de los ejes del sistema de coordenadas


ejes=[0 tamanyoEjes,0 0;0 0 tamanyoEjes 0;0 0 0 tamanyoEjes;1 1 1 1];
ejes = matrizTransformacion * ejes;
ejeX_H = plot3([ejes(1,1) ejes(1,2)],[ejes(2,1) ejes(2,2)],[ejes(3,1) ejes(3,2)],'r','LineWidth',grosorLinea);
ejeY_H = plot3([ejes(1,1) ejes(1,3)],[ejes(2,1) ejes(2,3)],[ejes(3,1) ejes(3,3)],'g','LineWidth',grosorLinea);
ejeZ_H = plot3([ejes(1,1) ejes(1,4)],[ejes(2,1) ejes(2,4)],[ejes(3,1) ejes(3,4)],'b','LineWidth',grosorLinea);
plot3(ejes(1,1),ejes(2,1),ejes(3,1),'k.');
texto=sprintf('Z_%s',etiqueta);
textoZ_H = text(ejes(1,4)-15,ejes(2,4)-15,ejes(3,4)-15,texto);
texto=sprintf('X_%s',etiqueta);
textoX_H = text(ejes(1,2)-15,ejes(2,2)-15,ejes(3,2)-15,texto);
texto=sprintf('Y_%s',etiqueta);
textoY_H = text(ejes(1,3)-15,ejes(2,3)-15,ejes(3,3)-15,texto);