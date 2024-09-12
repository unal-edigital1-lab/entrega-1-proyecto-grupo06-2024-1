`timescale 1ns / 1ps

module fsmcontrol_tb;

// Inputs
reg clk;
reg rst;
reg sound;
reg d;
reg sting;
reg food;
reg acc;

// Outputs
wire [2:0] NH;
wire [2:0] NS;
wire [2:0] NF;
wire [2:0] NE;

// (UUT)
fsmcontrol uut (
    .clk(clk),
    .rst(rst),
    .sound(sound),
    .d(d),
    .sting(sting),
    .food(food),
    .acc(acc),
    .NH(NH),
    .NS(NS),
    .NF(NF),
    .NE(NE)
);

// Clock 
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period of 10 ns
end

// Monitor the changes in the signals
initial begin
    $monitor("Time=%0t | NH=%d, NS=%d, NF=%d, NE=%d | sound=%b, d=%b, sting=%b, food=%b, acc=%b", 
              $time, NH, NS, NF, NE, sound, d, sting, food, acc);
end

// Stimulus process
initial begin
    // Initialize Inputs
    rst = 1;
    sound = 0;
    d = 0;
    sting = 0;
    food = 0;
    acc = 0;

    // Reset
    #20 rst = 0; // Release reset after 20 ns
    
    // Step 1: Pasar tiempo para subir NE
    acc = 1;
    #3000;  
    acc = 0;

    // Step 2: Pulso para incrementar 1 NH
    #200;
    food = 1; 
    #300;  
    food = 0;

    // Step 3: Pulso para incrementar 1 NS
    #200;
    sting = 1; 
    #50; 
    sting = 0;
    
    #300;
    
    // Repite food sostenido
    #200;
    food = 1; 
    #600; 
    food = 0;
    
    // Repite sting sostenido
    #200;
    sting = 1; 
    #300; 
    sting = 0;

    // Step 4: Incrementa NF y decrece NE
    #200;
    sound = 1;
    #200; // Aca es solo para ver NF subir sin perder NE
    d = 1;
    #300;
    sound = 0;
    d = 0;

    
    #200;  
    
    // Step 6: Bajar NE
    d = 1; 
    #1000; 
    d = 0;
    #200;
    sound = 1; 
    #1000; 
    sound = 0;

    // Step 7: Deja pasar tiempo
    #200;
 
    #20000; 

    
    acc = 1;
    #30000; // acelerado para finalizar y bajar todos 

    $display("Test completed.");
    $stop;
end

endmodule
