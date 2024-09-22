module sensor_sonido(
    input wire clk,          // Reloj de la FPGA
    input wire sensor_input, // Entrada del sensor KY-037 (DO)
    output reg ruido_detectado // Salida: 1 si detecta ruido, 0 si no
);

    always @(posedge clk) begin
        // Simplemente se asigna el valor del sensor a la salida
        if (sensor_input == 1) begin
            ruido_detectado <= 1; // Detecta ruido
        end else begin
            ruido_detectado <= 0; // No detecta ruido
        end
    end

endmodule