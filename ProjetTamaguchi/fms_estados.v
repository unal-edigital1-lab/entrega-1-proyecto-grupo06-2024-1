module fms_estados (
    input wire clk,           // Señal de reloj
    input wire reset_n,       // Señal de reset negada (activa en 0)
    input wire test_n,        // Señal de test negada (botón activo en 0)
    input wire [2:0] hambre,  // Nivel de hambre (1 a 5)
    input wire [2:0] diversion, // Nivel de diversión (1 a 5)
    input wire ultrasonido_n, // Sensor ultrasonido negado (0 si detecta presencia)
    input wire ruido_n,       // Sensor de ruido negado (0 si detecta ruido)
    output reg [2:0] estado   // Estado actual del tamagotchi (codificado en 3 bits)
);

// Definición de los estados
localparam NEUTRO     = 3'b000,
           FELIZ      = 3'b001,
           TRISTE     = 3'b010,
           CANSADO    = 3'b011,
           HAMBRIENTO = 3'b100,
           MUERTO     = 3'b101;

reg [2:0] next_estado;       // Estado siguiente
reg [31:0] test_counter;     // Contador para detectar 5 segundos en modo test
reg test_mode;               // Bandera para el modo test

// Máquina de estados secuencial basada en clk
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        estado <= NEUTRO;    // Estado inicial Neutro en reset (reset negado, activo bajo)
        test_counter <= 0;
        test_mode <= 0;
    end else begin
        // Modo test: Si el botón test está presionado por más de 5 segundos, cambia de estado
        if (~test_n) begin
            test_counter <= test_counter + 1;
            if (test_counter >= 5000000) begin
                test_counter <= 0;
                test_mode <= 1;  // Cambia el estado en modo test
            end
        end else begin
            test_counter <= 0;
            test_mode <= 0;
        end

        // Transición de estados basados en modo test o en reglas
        if (test_mode) begin
            // Secuencia de estados en modo test (los niveles son ignorados)
            case (estado)
                NEUTRO:     next_estado = FELIZ;
                FELIZ:      next_estado = TRISTE;
                TRISTE:     next_estado = CANSADO;
                CANSADO:    next_estado = HAMBRIENTO;
                HAMBRIENTO: next_estado = MUERTO;
                MUERTO:     next_estado = NEUTRO;
                default:    next_estado = NEUTRO;
            endcase
        end else begin
            // Transiciones normales según niveles y sensores
            case (estado)
                NEUTRO: begin
                    if (hambre >= 4)
                        next_estado = HAMBRIENTO;
                    else if (diversion >= 4 && hambre <= 2)
                        next_estado = FELIZ;
                    else if (diversion <= 2 || hambre >= 4)
                        next_estado = TRISTE;
                    else if (~ultrasonido_n || ~ruido_n)  // Sensores activos bajos
                        next_estado = CANSADO;
                    else
                        next_estado = NEUTRO;
                end
                
                FELIZ: begin
                    if (hambre >= 3 || diversion < 4)
                        next_estado = NEUTRO;
                    else
                        next_estado = FELIZ;
                end
                
                TRISTE: begin
                    if (hambre < 4 && diversion > 2)
                        next_estado = NEUTRO;
                    else
                        next_estado = TRISTE;
                end
                
                CANSADO: begin
                    if (ultrasonido_n && ruido_n)  // Sin presencia ni ruido (entradas negadas)
                        next_estado = NEUTRO;
                    else if (hambre == 5 && diversion == 1)
                        next_estado = MUERTO;
                    else
                        next_estado = CANSADO;
                end
                
                HAMBRIENTO: begin
                    if (hambre < 4)
                        next_estado = NEUTRO;
                    else if (hambre == 5 && diversion == 1)
                        next_estado = MUERTO;
                    else
                        next_estado = HAMBRIENTO;
                end
                
                MUERTO: begin
                    next_estado = MUERTO;  // No hay retorno desde el estado Muerto
                end
                
                default: next_estado = NEUTRO;
            endcase
        end

        // Actualiza el estado con el siguiente estado
        estado <= next_estado;
    end
end

endmodule





