function dibudos(q1, q2)
    % Dibuja dos vectores:
    % - El primero (referencia) en AMARILLO ('y') según el manual.
    % - El segundo (real) en ROJO ('r').
    
    plot(q1, 'y', 'LineWidth', 1.5);
    hold on;                         
    grid on;                        
    plot(q2, 'r', 'LineWidth', 1.5); 
    
    % Leyenda
    legend('Referencia (q1)', 'Real (q2)');
    xlabel('Muestras (Tiempo)');
    ylabel('Amplitud (rad o rad/s)');
    title('Comparación de Trayectorias');
    
    hold off;
end
