function [objetoH, nubePuntos] = cargarObjeto(nombreFichero, color, sistemaCoordenadas, tamanyoEjes)
light
load(nombreFichero);
nubePuntos = elemento.V';
objeto = patch('faces', elemento.F, 'vertices' ,nubePuntos(1:3,:)');
set(objeto, 'facec', color);
set(objeto, 'EdgeColor','none');
if sistemaCoordenadas
    set(objeto, 'FaceAlpha',0.1);
    T_00=[1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
    [ejeX, ejeY, ejeZ, textoX, textoY, textoZ] = dibujarSC(T_00, 'o', tamanyoEjes, 2);
else
    ejeX=0;
    ejeY=0;
    ejeZ=0;
    textoX=0;
    textoY=0;
    textoZ=0;
end

objetoH.objeto = objeto;
objetoH.ejeX = ejeX;
objetoH.ejeY = ejeY;
objetoH.ejeZ = ejeZ;
objetoH.textoX = textoX;
objetoH.textoY = textoY;
objetoH.textoZ = textoZ;
objetoH.tamanyoEjes = tamanyoEjes;