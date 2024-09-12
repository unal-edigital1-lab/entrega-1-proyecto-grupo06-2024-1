`timescale 1ns / 1ps

module fsmlevel_tb;

// Inputs
reg [2:0] NH, NS, NF, NE;
reg clk, reset;

// Outputs
wire [2:0] state;

// Instantiate the Unit Under Test (UUT)
fsmlevel uut (
    .NH(NH),
    .NS(NS),
    .NF(NF),
    .NE(NE),
    .clk(clk),
    .reset(reset),
    .state(state)
);

// Correct Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Genera un ciclo de reloj alternando cada 5 ns (Período total de 10 ns)
end

initial begin
    // Initialize Inputs
    reset = 0;
    NH = 3'b000;
    NS = 3'b000;
    NF = 3'b000;
    NE = 3'b000;

    // Apply reset
    #10 reset = 1;
    #10 reset = 0;

    // Esperar suficiente tiempo para que el FSM procese el reset correctamente
    #20; 

	 // Estados 1,3 y 5 son simbolicos, al cumplir el anterior par, pasan al siguiente ya que para cumplir este impar implica que cumple el siguiente par
	 
	 
    // Test Case 1: Reset State
    NH = 3'b000;
    NS = 3'b000;
    NF = 3'b000;
    NE = 3'b000;
    #50; // Prolongar el tiempo para esperar la respuesta
    if (state != 3'b000) $display("Test Case 1 Failed: Not Coincide.");

    // Test Case 2: NH = 1, Se espera 0, hambriento = 3'b000
    NH = 3'b001; // NH = 1
    NS = 3'b010; // NS varied (within range 1-5)
    NF = 3'b011; // NF varied (within range 1-5)
    NE = 3'b100; // NE varied (within range 1-5)
    #50; // Prolongar el tiempo de espera
    

    // Test Case 3: NH = 3, Se espera 2, al pasar de 0 ya cumple el 1 y pasa al 2
    NH = 3'b011; // NH = 3
    NS = 3'b001; // NS < 1
    NF = 3'b100; // NF varied (within range 1-5)
    NE = 3'b011; // NE varied (within range 1-5)
    #50; // Prolongar el tiempo de espera
    
    // Test Case 4: NH = 3, NS = 1, Se espera = 3'b010
    NH = 3'b011; 
    NS = 3'b001; // NS = 1
    NF = 3'b100; // NF < 3
    NE = 3'b010; // NE varied (within range 1-5)
    #50; // Prolongar el tiempo de espera
    

    // Test Case 5: NH = 3, NS = 3, Se espera 4, al pasar de 2 ya cumple el 3 y pasa al 4
    NH = 3'b011; 
    NS = 3'b011; // NS = 3
    NF = 3'b001; // NF < 3
    NE = 3'b001; // NE varied (within range 1-5)
    #50; // Prolongar el tiempo de espera
    

    // Test Case 6: NH = 3, NS = 3, NF = 1, Expect state = 3'b100
    NH = 3'b011; 
    NS = 3'b011;
    NF = 3'b001; // NF = 1
    NE = 3'b101; // NE varied (within range 1-5)
    #50; // Prolongar el tiempo de espera
    
    // Test Case 7: NH = 3, NS = 3, NF = 3, Se espera 6, al pasar de 2 ya cumple el 5 y pasa al 6
    NH = 3'b011; 
    NS = 3'b011;
    NF = 3'b011; // NF = 3
    NE = 3'b001; // NE varied < 3
    #50; // Prolongar el tiempo de espera
    
    // Test Case 8: NH = 3, NS = 3, NF = 3, NE = 1, Expect state = 3'b110
    NH = 3'b011; 
    NS = 3'b011;
    NF = 3'b011;
    NE = 3'b001; // NE = 1
    #50; // Prolongar el tiempo de espera
    

    // Test Case 9: NH = 3, NS = 3, NF = 3, NE = 3, Expect state = 3'b111
    NH = 3'b011; 
    NS = 3'b011;
    NF = 3'b011;
    NE = 3'b011; // NE = 3
    #50; // Prolongar el tiempo de espera
    

    $display("Test completed.");
    $stop;
end

endmodule
