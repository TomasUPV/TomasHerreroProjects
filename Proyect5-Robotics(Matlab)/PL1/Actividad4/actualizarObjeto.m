function actualizarObjeto(objetoH, T, nubePuntos)
set(objetoH.objeto,'Vertices',nubePuntos(1:3,:)') 
if objetoH.ejeX ~= 0
    ejes=[0 objetoH.tamanyoEjes,0 0;0 0 objetoH.tamanyoEjes 0;0 0 0 objetoH.tamanyoEjes;1 1 1 1];
    ejesT = T*ejes;
    set(objetoH.ejeX,'xdata',[ejesT(1,1) ejesT(1,2)],'ydata',[ejesT(2,1) ejesT(2,2)],'zdata',[ejesT(3,1) ejesT(3,2)]);
    set(objetoH.ejeY,'xdata',[ejesT(1,1) ejesT(1,3)],'ydata',[ejesT(2,1) ejesT(2,3)],'zdata',[ejesT(3,1) ejesT(3,3)]);
    set(objetoH.ejeZ,'xdata',[ejesT(1,1) ejesT(1,4)],'ydata',[ejesT(2,1) ejesT(2,4)],'zdata',[ejesT(3,1) ejesT(3,4)]);
    set(objetoH.textoZ,'position',[ejesT(1,4)-15,ejesT(2,4)-15,ejesT(3,4)-15]);
    set(objetoH.textoX,'position',[ejesT(1,2)-15,ejesT(2,2)-15,ejesT(3,2)-15]);
    set(objetoH.textoY,'position',[ejesT(1,3)-15,ejesT(2,3)-15,ejesT(3,3)-15]);
end
drawnow
