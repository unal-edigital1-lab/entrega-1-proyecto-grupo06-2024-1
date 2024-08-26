module debounce (
    input wire clk,        // Señal de reloj de 50 MHz
    input wire btn_in,     // Entrada del pulsador
    output reg btn_out     // Salida estable del pulsador
);

    reg [19:0] counter;    // Contador de 20 bits
    reg btn_prev;          // Estado anterior del pulsador

    always @(posedge clk) begin
        // Comprobamos si el estado actual del pulsador es diferente al anterior
        if (btn_in ^ btn_prev) begin
            counter <= 20'b0; // Si es diferente, reiniciamos el contador
            btn_prev <= btn_in; // Actualizamos el estado anterior
        end else begin
            if (counter[19] == 1'b1) begin
                // Si el bit más significativo del contador es 1, la pulsación es estable
                btn_out <= btn_prev; // Ponemos el valor estable en la salida
            end else begin
                counter <= counter + 1'b1; // Si no, incrementamos el contador
            end
        end
    end

endmodule
