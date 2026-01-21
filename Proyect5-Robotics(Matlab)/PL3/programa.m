function posicionesArticulaciones = programa(parametrosDH, funcionEvalDH, funcionCinInv)
% solo se pueden utilizar funciones moveL y moveC
posiciones = moveL(parametrosDH, [515 100 712]', [515 -100 712]', [0 0.70710 0 0.70710], 2, 10, funcionEvalDH, funcionCinInv);

posicionesArticulaciones = [posiciones];

posiciones = moveL(parametrosDH, [515 -100 712]', [515 -100 612]', [0 0.70710 0 0.70710], 2, 10, funcionEvalDH, funcionCinInv);

posicionesArticulaciones = [posicionesArticulaciones; posiciones];

posiciones = moveL(parametrosDH, [515 -100 612]', [515 100 612]', [0 0.70710 0 0.70710], 2, 10, funcionEvalDH, funcionCinInv);

posicionesArticulaciones = [posicionesArticulaciones; posiciones];

posiciones = moveL(parametrosDH, [515 100 612]', [515 100 712]', [0 0.70710 0 0.70710], 2, 10, funcionEvalDH, funcionCinInv);

posicionesArticulaciones = [posicionesArticulaciones; posiciones];
