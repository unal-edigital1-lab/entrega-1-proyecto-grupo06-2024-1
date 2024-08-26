module fsmlevel (
    input wire [2:0] NH, NS, NF, NE, // Inputs de 3 bits
    input wire clk, reset,           // Reloj y reset
    output reg [2:0] state           // Output de 3 bits
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;  // Estado inicial en caso de reset
    end else begin
        // Evaluación de NH
        if (NH >= 1 && NH <= 2) begin
            state <= 3'b000;
        end else if (NH >= 3 && NH <= 5) begin
            state <= 3'b001;
            // Evaluación de NS
            if (NS == 1) begin
                state <= 3'b010;
            end else if (NS >= 2 && NS <= 5) begin
                state <= 3'b011;
                // Evaluación de NF
                if (NF >= 1 && NF <= 2) begin
                    state <= 3'b100;
                end else if (NF >= 3 && NF <= 5) begin
                    state <= 3'b101;
                    // Evaluación de NE
                    if (NE >= 1 && NE <= 2) begin
                        state <= 3'b110;
                    end else if (NE >= 3 && NE <= 5) begin
                        state <= 3'b111;
                    end
                end
            end
        end
    end
end

endmodule
