module niveles (
    input wire clk,               // Señal de reloj
    input wire alimentar,         // Botón para alimentar (lógica negada)
    input wire jugar,             // Botón para jugar (lógica negada)
    input wire reset,             // Botón de reset (lógica negada)
    input wire test,              // Botón de test (lógica negada)
    output reg [2:0] nivel_hambre,  // Nivel de hambre (1 a 5)
    output reg [2:0] nivel_diversion, // Nivel de diversión (1 a 5)
    output reg reset_debounced,   // Señal de reset después del antirrebote
    output reg test_debounced     // Señal de test después del antirrebote
);

parameter CLK_FREQ = 50000000;   // Frecuencia del reloj en Hz (50 MHz por ejemplo)
parameter SEGUNDOS_EN_MINUTO = 25;

reg [31:0] contador_reloj = 0;  // Contador para dividir el reloj
reg minuto;                      // Señal interna que indica que ha pasado 1 minuto

// Definiciones para antirrebote
reg [2:0] alimentar_shift, jugar_shift, reset_shift, test_shift; // Shift registers para antirrebote
wire alimentar_db, jugar_db, reset_db, test_db;

// Antirrebote por desplazamiento
always @(posedge clk) begin
    alimentar_shift <= {alimentar_shift[1:0], alimentar};
    jugar_shift     <= {jugar_shift[1:0], jugar};
    reset_shift     <= {reset_shift[1:0], reset};
    test_shift      <= {test_shift[1:0], test};
end

// Señales debounced (filtro de 3 bits: todas deben ser iguales para considerar estable la señal)
assign alimentar_db = &alimentar_shift;
assign jugar_db     = &jugar_shift;
assign reset_db     = &reset_shift;
assign test_db      = &test_shift;

// Inicialización de los niveles
initial begin
    nivel_hambre = 3'd1;      // Nivel inicial de hambre
    nivel_diversion = 3'd5;   // Nivel inicial de diversión
    minuto = 0;               // Inicialmente no ha pasado ningún minuto
end

// Lógica para generar la señal de "minuto" usando el reloj
always @(posedge clk) begin
    if (contador_reloj >= CLK_FREQ * SEGUNDOS_EN_MINUTO - 1) begin
        contador_reloj <= 0;   // Reiniciar el contador
        minuto <= 1;           // Señal de que ha pasado 1 minuto
    end else begin
        contador_reloj <= contador_reloj + 1;
        minuto <= 0;           // Mientras no pase un minuto, esta señal permanece en 0
    end
end

// Lógica secuencial para ajustar los niveles de hambre y diversión
always @(posedge clk) begin
    if (!reset_db) begin
        nivel_hambre <= 3'd1;
        nivel_diversion <= 3'd5; // Ambos niveles se reinician a sus valores iniciales
    end else begin
        // Alimentar al Tamagotchi si se presiona el botón alimentar (lógica negada)
        if (!alimentar_db && alimentar_shift[2:1] == 2'b01 && nivel_hambre > 1) begin
            nivel_hambre <= nivel_hambre - 1;  // Bajar nivel de hambre
        end

        // Jugar con el Tamagotchi si se presiona el botón jugar (lógica negada)
        if (!jugar_db && jugar_shift[2:1] == 2'b01 && nivel_diversion < 5) begin
            nivel_diversion <= nivel_diversion + 1;  // Subir nivel de diversión
        end

        // Cada vez que pasa un minuto, ajustar niveles
        if (minuto) begin
            if (nivel_hambre < 5) begin
                nivel_hambre <= nivel_hambre + 1;
            end

            if (nivel_diversion > 1) begin
                nivel_diversion <= nivel_diversion - 1;
            end
        end
    end
end


endmodule


