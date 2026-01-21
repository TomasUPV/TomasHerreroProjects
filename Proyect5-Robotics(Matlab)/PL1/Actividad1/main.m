% 1. --- Configuración del Entorno ---
close all
clc
clear all

entorno=1000;
crearEntorno(1, entorno, entorno, entorno);

T_00=[1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1;]

%2. Dibujar los ejes del sistemas coordendas 0

dibujarSC(T_00, '0', 200, 2);

%3. Dibujar los ejes del sistemas coordendas 1

T_01 = tras(-500, 500, 500);
dibujarSC(T_01, '1', 200, 2);
