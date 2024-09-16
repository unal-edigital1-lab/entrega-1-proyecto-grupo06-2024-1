//`include "fms_estado.v"
`timescale 1ns / 1ps

module fms_estado_tb;

// Señales del testbench
reg clk;
reg reset;
reg test;
reg [2:0] hambre;
reg [2:0] diversion;
reg ultrasonido;
reg ruido;
wire [2:0] estado;

// Instancia del módulo bajo prueba (UUT)
fms_estado uut (
    .clk(clk),
    .reset(reset),
    .test(test),
    .hambre(hambre),
    .diversion(diversion),
    .ultrasonido(ultrasonido),
    .ruido(ruido),
    .estado(estado)
);

// Generador de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Reloj de 10ns de periodo
end

// Proceso de prueba
initial begin
    // Inicializar las señales
    reset = 1;
    test = 0;
    hambre = 3'd0;
    diversion = 3'd0;
    ultrasonido = 0;
    ruido = 0;
    
    // Liberar el reset
    #10;
    reset = 0;
    
    // Prueba 1: Navegación manual por estados usando el botón `test`
    #10; test = 1; #10; test = 0;  // De NEUTRO a FELIZ
    #10; test = 1; #10; test = 0;  // De FELIZ a TRISTE
    #10; test = 1; #10; test = 0;  // De TRISTE a CANSADO
    #10; test = 1; #10; test = 0;  // De CANSADO a HAMBRIENTO
    #10; test = 1; #10; test = 0;  // De HAMBRIENTO a MUERTO
    #10; test = 1; #10; test = 0;  // De MUERTO a NEUTRO
    
    // Prueba 2: Cambio de estado automático basado en entradas
    // Estado: Triste (diversión baja y presencia detectada por ultrasonido)
    #20; diversion = 3'd1; ultrasonido = 1;
    
    // Estado: Hambriento (nivel de hambre alto)
    #20; hambre = 3'd4; diversion = 3'd3; ultrasonido = 0;
    
    // Estado: Muerto (nivel de hambre máximo)
    #20; hambre = 3'd5;
    
    // Estado: Feliz (diversión alta, hambre baja, sin presencia)
    #20; hambre = 3'd1; diversion = 3'd5; ultrasonido = 0;
    
    // Estado: Cansado (ruido detectado)
    #20; ruido = 1;
    
    // Prueba 3: Reiniciar la máquina de estados
    #20; reset = 1; #10; reset = 0;
    
    // Fin de la simulación
    #100;
    //$stop;
end

initial begin:TEST_CASE
    $dumpfile("fms_estado_tb.vcd");
    $dumpvars(-1, uut);
    #400 $finish;
end

endmodule
