module maquina_estados (
    input wire clk,             // Señal de reloj
    input wire reset,           // Señal de reset para volver al estado inicial
    input wire test,            // Botón de test para navegar entre estados
    input wire [2:0] nivel_hambre,   // Nivel de hambre (1 a 5)
    input wire [2:0] nivel_diversion, // Nivel de diversión (1 a 5)
    output reg [2:0] estado_actual    // Estado actual
);

// Definición de estados
parameter NEUTRO     = 3'b000;
parameter FELIZ      = 3'b001;
parameter TRISTE     = 3'b010;
parameter CANSADO    = 3'b011;
parameter HAMBRIENTO = 3'b100;
parameter MUERTO     = 3'b101;

// Registro para almacenar el próximo estado
reg [2:0] estado_siguiente;
reg test_flag;  // Bandera para capturar el cambio de test (presionado una sola vez)

// Bloque para manejar el estado actual con reset y actualización en cada flanco de reloj
always @(posedge clk or posedge reset) begin
    if (reset) begin
        estado_actual <= NEUTRO; // Estado inicial en Neutro
    end else begin
        estado_actual <= estado_siguiente;
    end
end

// Lógica para capturar la señal de test (evitar múltiples detecciones por un solo pulso)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        test_flag <= 1'b0;
    end else if (test && !test_flag) begin
        test_flag <= 1'b1;  // Marca que el botón ha sido presionado
    end else if (!test) begin
        test_flag <= 1'b0;  // Libera la bandera cuando se suelta el botón
    end
end

// Lógica de la máquina de estados
always @(*) begin
    // Por defecto el próximo estado es el estado actual
    estado_siguiente = estado_actual;

    // Prioridad al modo test para navegar manualmente
    if (test_flag) begin
        case (estado_actual)
            NEUTRO:     estado_siguiente = FELIZ;
            FELIZ:      estado_siguiente = TRISTE;
            TRISTE:     estado_siguiente = CANSADO;
            CANSADO:    estado_siguiente = HAMBRIENTO;
            HAMBRIENTO: estado_siguiente = MUERTO;
            MUERTO:     estado_siguiente = NEUTRO;
            default:    estado_siguiente = NEUTRO;
        endcase
    end else begin
        // Lógica de transición automática entre estados basado en los niveles de hambre y diversión
        case (estado_actual)
            NEUTRO: begin
                if (nivel_hambre >= 4)
                    estado_siguiente = HAMBRIENTO;
                else if (nivel_diversion >= 4 && nivel_hambre <= 2)
                    estado_siguiente = FELIZ;
                else if (nivel_diversion <= 2 && nivel_hambre <= 3)
                    estado_siguiente = TRISTE;
            end

            FELIZ: begin
                if (nivel_hambre >= 4)
                    estado_siguiente = HAMBRIENTO;
                else if (nivel_diversion <= 2)
                    estado_siguiente = TRISTE;
            end

            TRISTE: begin
                if (nivel_hambre >= 4)
                    estado_siguiente = HAMBRIENTO;
                else if (nivel_diversion >= 4)
                    estado_siguiente = FELIZ;
            end

            CANSADO: begin
                if (nivel_diversion <= 3)
                    estado_siguiente = NEUTRO;
                else if (nivel_hambre >= 4)
                    estado_siguiente = HAMBRIENTO;
            end

            HAMBRIENTO: begin
                if (nivel_hambre == 5) 
                    estado_siguiente = MUERTO;
                else if (nivel_hambre <= 2 && nivel_diversion >= 4)
                    estado_siguiente = FELIZ;
                else if (nivel_hambre <= 2 && nivel_diversion <= 2)
                    estado_siguiente = TRISTE;
                else
                    estado_siguiente = NEUTRO;
            end

            MUERTO: begin
                estado_siguiente = MUERTO;  // Una vez muerto, no hay retorno
            end

            default: begin
                estado_siguiente = NEUTRO;  // Estado por defecto si hay error
            end
        endcase
    end
end

endmodule
