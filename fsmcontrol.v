module fsmcontrol (
    input wire clk,
    input wire rst,
    input wire sound,
    input wire d,
    input wire sting,
    input wire food,
    input wire acc,
    output reg [2:0] NH,
    output reg [2:0] NS,
    output reg [2:0] NF,
    output reg [2:0] NE
);

    reg [5:0] second_counter;
    reg [5:0] minute_counter;

    // Timer
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            second_counter <= 0;
            minute_counter <= 0;
        end else if (acc == 0) begin
            if (second_counter < 59)
                second_counter <= second_counter + 1;
            else begin
                second_counter <= 0;
                if (minute_counter < 59)
                    minute_counter <= minute_counter + 1;
                else
                    minute_counter <= 0;
            end
        end else begin
            if (second_counter + 30 < 60)
                second_counter <= second_counter + 30;
            else begin
                second_counter <= second_counter + 30 - 60;
                if (minute_counter < 59)
                    minute_counter <= minute_counter + 1;
                else
                    minute_counter <= 0;
            end
        end
    end

    // Control of NH
    reg [3:0] food_timer;
    reg food_incremented; // Esto esta para evitar incrementos repentinos 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            NH <= 3'd1;
            food_timer <= 0;
            food_incremented <= 0;
        end else begin
            if (food) begin
                if (food_timer < 10) begin
                    food_timer <= food_timer + 1;
                    food_incremented <= 0; // resetea la bandera
                end else if (!food_incremented) begin
                    food_timer <= 0;
                    NH <= (NH < 5) ? NH + 1 : NH;
                    food_incremented <= 1; // Evita multiples incrementos
                end
            end else begin
                food_timer <= 0;
                food_incremented <= 0; // Evita acumular la bandera
            end

            if (minute_counter == 30)
                NH <= (NH > 1) ? NH - 1 : NH;
        end
    end

    // Control of NS
    reg [1:0] sting_timer;
    reg sting_incremented; 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            NS <= 3'd1;
            sting_timer <= 0;
            sting_incremented <= 0;
        end else begin
            if (sting) begin
                if (sting_timer < 3) begin
                    sting_timer <= sting_timer + 1;
                    sting_incremented <= 0; 
                end else if (!sting_incremented) begin
                    sting_timer <= 0;
                    NS <= (NS < 5) ? NS + 1 : NS;
                    sting_incremented <= 1; 
                end
            end else begin
                sting_timer <= 0;
                sting_incremented <= 0; 
            end

            if (minute_counter == 60)
                NS <= (NS > 1) ? NS - 1 : NS;
        end
    end

    // Control of NF
    reg [5:0] d_timer, sound_timer;
    reg [1:0] d_increment, sound_increment;
    reg d_incremented, sound_incremented; 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            NF <= 3'd1;
            d_timer <= 0;
            sound_timer <= 0;
            d_increment <= 0;
            sound_increment <= 0;
            d_incremented <= 0;
            sound_incremented <= 0;
        end else begin
            // D Timer
            if (d && d_increment < 2) begin
                if (d_timer < 30) begin
                    d_timer <= d_timer + 1;
                    d_incremented <= 0; 
                end else if (!d_incremented) begin
                    d_timer <= 0;
                    d_increment <= d_increment + 1;
                    NF <= (NF < 5) ? NF + 1 : NF;
                    d_incremented <= 1; 
                end
            end else begin
                d_timer <= 0;
                d_incremented <= 0; 
            end

            // Sound Timer
            if (sound && sound_increment < 2) begin
                if (sound_timer < 15) begin
                    sound_timer <= sound_timer + 1;
                    sound_incremented <= 0;
                end else if (!sound_incremented) begin
                    sound_timer <= 0;
                    sound_increment <= sound_increment + 1;
                    NF <= (NF < 5) ? NF + 1 : NF;
                    sound_incremented <= 1; 
                end
            end else begin
                sound_timer <= 0;
                sound_incremented <= 0; 
            end

            if (minute_counter == 15)
                NF <= (NF > 1) ? NF - 1 : NF;
        end
    end

    // Control of NE
    reg [5:0] ne_timer;
    reg ne_incremented;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            NE <= 3'd1;
            ne_timer <= 0;
            ne_incremented <= 0; 
        end else begin
            
            if ((d || sound) && ne_timer >= 30) begin
                NE <= (NE > 1) ? NE - 1 : NE;
            end else if (d || sound)
                ne_timer <= ne_timer + 1;
            else
                ne_timer <= 0;

            
            if (minute_counter == 15 && !ne_incremented) begin
                NE <= (NE < 5) ? NE + 1 : NE;
                ne_incremented <= 1;
            end else if (minute_counter != 15) begin
                ne_incremented <= 0; 
            end
        end
    end

endmodule
