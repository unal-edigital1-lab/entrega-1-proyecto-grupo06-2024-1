module Ultrasonic_Sensor ( 
    input wire clk,           // Señal de reloj
    input wire ech,           // Señal del pulso "echo"
    output reg trigger_o,     // Señal de activación del "trigger"
    output reg object_detected // Salida que indica si se detectó un objeto
);

    // Parámetros para el cálculo de tiempo
    parameter CLOCK_FREQ = 50000000; // Frecuencia del reloj en Hz (ej. 50MHz)
    parameter SOUND_SPEED = 34300;   // Velocidad del sonido en cm/s
    parameter DISTANCE_THRESHOLD = 10; // Umbral de 10 cm

    // Calculamos el tiempo en ciclos de reloj para que el eco vuelva
    parameter TIME_THRESHOLD = (4 * DISTANCE_THRESHOLD * CLOCK_FREQ) / SOUND_SPEED;

    reg [31:0] echo_time; // Contador de tiempo para el pulso "echo"
    reg measuring;        // Bandera que indica si estamos midiendo el tiempo
    reg [23:0] trigger_count; // Contador para el tiempo de activación del trigger
    reg [31:0] delay_count;   // Contador para el retraso entre triggers

    // Inicialización de registros
    initial begin
        measuring <= 0;
        echo_time <= 0;
        trigger_count <= 0;
        delay_count <= 0;
        object_detected <= 0;
        trigger_o <= 0;
    end

    // FSM para generar el pulso "trigger" (10us cada 60ms aprox.)
    always @(posedge clk) begin
        if (delay_count == 0) begin
            if (trigger_count == 0) begin
                trigger_o <= 1; // Activa el trigger por 10us
                trigger_count <= CLOCK_FREQ / 100000; // 10us a 50MHz
            end else if (trigger_count == 1) begin
                trigger_o <= 0; // Desactiva el trigger
                trigger_count <= 0;
                delay_count <= CLOCK_FREQ / 16; // Retardo de aprox. 60ms entre triggers (CLOCK_FREQ/16 aprox 3ms)
            end else begin
                trigger_count <= trigger_count - 1;
            end
        end else begin
            delay_count <= delay_count - 1;
        end
    end

    // Estado de medición de la señal "echo"
    always @(posedge clk) begin
        if (trigger_o == 0 && ech == 1 && !measuring) begin
            // Comenzamos a medir cuando recibimos el flanco ascendente de "echo"
            measuring <= 1;
            echo_time <= 0;
        end else if (measuring) begin
            if (ech == 0) begin
                // Terminamos de medir cuando recibimos el flanco descendente de "echo"
                measuring <= 0;

                // Si el tiempo es menor al umbral, detectamos el objeto
                if (echo_time < TIME_THRESHOLD) begin
                    object_detected <= 0;
                end else begin
                    object_detected <= 1;
                end
            end else begin
                // Seguimos midiendo el tiempo del pulso "echo"
                echo_time <= echo_time + 1;
            end
        end
    end

endmodule


