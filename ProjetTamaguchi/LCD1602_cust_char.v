module LCD1602_cust_char #(parameter num_commands = 3, 
                                      num_data_all = 384,  // Ahora hay 240 filas en el archivo de datos
                                      char_data = 8, 
                                      num_cgram_addrs = 6,
                                      COUNT_MAX = 800000)(
    input clk,            
    input reset,          
    input ready_i,
    input [2:0] control_signal,  // Señal de control de entrada (valores de 0 a 7)
    input [2:0] nivel_hambre,    // Entrada de nivel de hambre (3 bits)
    input [2:0] nivel_diversion, // Entrada de nivel de diversión (3 bits)
    output reg rs,        
    output reg rw,
    output enable,    
    output reg [7:0] data
);

// Definir los estados del controlador
localparam IDLE = 0;
localparam INIT_CONFIG = 1;
localparam CLEAR_COUNTERS0 = 2;
localparam CREATE_CHARS = 3;
localparam CLEAR_COUNTERS1 = 4;
localparam SET_CURSOR_AND_WRITE = 5;
localparam WRITE_EXTRA_TEXT = 6;

localparam SET_CGRAM_ADDR = 0;
localparam WRITE_CHARS = 1;
localparam SET_CURSOR = 2;
localparam WRITE_LCD = 3;
localparam CHANGE_LINE = 4;

// Direcciones de escritura de la CGRAM 
localparam CGRAM_ADDR0 = 8'h40;
localparam CGRAM_ADDR1 = 8'h48;
localparam CGRAM_ADDR2 = 8'h50;
localparam CGRAM_ADDR3 = 8'h58;
localparam CGRAM_ADDR4 = 8'h60;
localparam CGRAM_ADDR5 = 8'h68;
localparam CGRAM_ADDR6 = 8'h70;



reg [3:0] fsm_state;
reg [3:0] next;
reg clk_16ms;

// Definir un contador para el divisor de frecuencia
reg [$clog2(COUNT_MAX)-1:0] counter_div_freq;

// Comandos de configuración
localparam CLEAR_DISPLAY = 8'h01;
localparam SHIFT_CURSOR_RIGHT = 8'h06;
localparam DISPON_CURSOROFF = 8'h0C;
localparam DISPON_CURSORBLINK = 8'h0E;
localparam LINES2_MATRIX5x8_MODE8bit = 8'h38;
localparam LINES2_MATRIX5x8_MODE4bit = 8'h28;
localparam LINES1_MATRIX5x8_MODE8bit = 8'h30;
localparam LINES1_MATRIX5x8_MODE4bit = 8'h20;
localparam START_2LINE = 8'hC0;



// Posiciones para escribir NH y ND en la segunda línea
// Posiciones para escribir NH y ND en las líneas correctas
localparam POS_NH = 8'h94;  // Dirección de la primera línea del LCD para "NH:"
localparam POS_ND = 8'hD4;  // Dirección de la segunda línea del LCD para "ND:"

reg [4:0] current, next1;



// Definir un contador para controlar el envío de comandos
reg [$clog2(num_commands):0] command_counter;
// Definir un contador para controlar el envío de cada dato
reg [$clog2(num_data_all):0] data_counter;
// Definir un contador para controlar el envío de caracteres a la CGRAM
reg [$clog2(char_data):0] char_counter;
// Definir un contador para controlar el envío de comandos
reg [$clog2(num_cgram_addrs):0] cgram_addrs_counter;

// Banco de registros
reg [7:0] data_memory [0: num_data_all-1];
reg [7:0] config_memory [0:num_commands-1]; 
reg [7:0] cgram_addrs [0: num_cgram_addrs-1];

reg [1:0] create_char_task;
reg init_config_executed;
wire done_cgram_write;
reg done_lcd_write;

// Variables para almacenar el nivel de hambre y diversión en ASCII
reg [7:0] dec_hambre;  
reg [7:0] dec_diversion;

initial begin
    fsm_state <= IDLE;
    data <= 'b0;
    command_counter <= 'b0;
    data_counter <= 'b0;
    rw <= 0;
    rs <= 0;
    clk_16ms <= 'b0;
    counter_div_freq <= 'b0;
    init_config_executed <= 'b0;
    cgram_addrs_counter <= 'b0; 
    char_counter <= 'b0;
    done_lcd_write <= 1'b0;
	 current = 0;
    next1 = 0;
	 


    create_char_task <= SET_CGRAM_ADDR;

    // Leer 240 datos del archivo de texto
    $readmemb("data.txt", data_memory);    
    config_memory[0] <= LINES2_MATRIX5x8_MODE8bit;
    config_memory[1] <= DISPON_CURSOROFF;
    config_memory[2] <= CLEAR_DISPLAY;

    cgram_addrs[0] <= CGRAM_ADDR0;
    cgram_addrs[1] <= CGRAM_ADDR1;
    cgram_addrs[2] <= CGRAM_ADDR2;
    cgram_addrs[3] <= CGRAM_ADDR3;
    cgram_addrs[4] <= CGRAM_ADDR4;
    cgram_addrs[5] <= CGRAM_ADDR5;
end

// Divisor de frecuencia para generar el enable cada 16ms
always @(posedge clk) begin
    if (counter_div_freq == COUNT_MAX-1) begin
        clk_16ms <= ~clk_16ms;
        counter_div_freq <= 0;
    end else begin
        counter_div_freq <= counter_div_freq + 1;
    end
end

// Conversión de los valores de nivel de hambre y diversión a decimal (ASCII)
always @(*) begin
    dec_hambre = 8'h30 + nivel_hambre;  // Convertir nivel de hambre a ASCII
    dec_diversion = 8'h30 + nivel_diversion;  // Convertir nivel de diversión a ASCII
end

// Máquina de estados
always @(posedge clk_16ms) begin
    if (reset == 0) begin
        fsm_state <= IDLE;
    end else begin
        fsm_state <= next;
    end
end

always @(*) begin
    case(fsm_state)
        IDLE: begin
            next <= (ready_i)? ((init_config_executed)? CREATE_CHARS : INIT_CONFIG) : IDLE;
        end
        INIT_CONFIG: begin 
            next <= (command_counter == num_commands)? CLEAR_COUNTERS0 : INIT_CONFIG;
        end
        CLEAR_COUNTERS0: begin
            next <= CREATE_CHARS;
        end
        CREATE_CHARS:begin
            next <= (done_cgram_write)? CLEAR_COUNTERS1 : CREATE_CHARS;
        end
        CLEAR_COUNTERS1: begin
            next <= SET_CURSOR_AND_WRITE;
        end
        SET_CURSOR_AND_WRITE: begin 
            next <= (done_lcd_write)? WRITE_EXTRA_TEXT : SET_CURSOR_AND_WRITE;
        end
        WRITE_EXTRA_TEXT: begin
            next <= (done_lcd_write)? CLEAR_COUNTERS0 : WRITE_EXTRA_TEXT;  // Volver al inicio después de escribir el texto extra
        end
        default: next = IDLE;
    endcase
end

always @(posedge clk_16ms) begin
    if (reset == 0) begin
        command_counter <= 'b0;
        data_counter <= 'b0;
        data <= 'b0;
        char_counter <= 'b0;
        init_config_executed <= 'b0;
        cgram_addrs_counter <= 'b0;
        done_lcd_write <= 1'b0;
		  current = 0;
        next1 = 0;
		 
    end else begin
        case (next)
            IDLE: begin
                char_counter <= 'b0;
                command_counter <= 'b0;
                data_counter <= 'b0;
                rs <= 'b0;
                cgram_addrs_counter <= 'b0;
                done_lcd_write <= 1'b0;
            end
            INIT_CONFIG: begin
                rs <= 'b0;
                command_counter <= command_counter + 1;
                data <= config_memory[command_counter];
                if(command_counter == num_commands-1) begin
                    init_config_executed <= 1'b1;
                end
            end
            CLEAR_COUNTERS0: begin
                data_counter <= 'b0;
                char_counter <= 'b0;
                create_char_task <= SET_CGRAM_ADDR;
                cgram_addrs_counter <= 'b0;
                done_lcd_write <= 1'b0;
                rs <= 'b0;
                data <= 'b0;
            end
            CREATE_CHARS: begin
                case(create_char_task)
                    SET_CGRAM_ADDR: begin 
                        rs <= 'b0; data <= cgram_addrs[cgram_addrs_counter]; 
                        create_char_task <= WRITE_CHARS; 
                    end
                    WRITE_CHARS: begin
                        rs <= 1; 
                        data <= data_memory[(control_signal * 48) + data_counter];  // Seleccionar el bloque correcto de datos
                        data_counter <= data_counter + 1;
                        if(char_counter == char_data -1) begin
                            char_counter = 0;
                            create_char_task <= SET_CGRAM_ADDR;
                            cgram_addrs_counter <= cgram_addrs_counter + 1;
                        end else begin
                            char_counter <= char_counter +1;
                        end
                    end
                endcase
            end
				
            CLEAR_COUNTERS1: begin
                data_counter <= 'b0;
                char_counter <= 'b0;
                create_char_task <= SET_CURSOR;
                cgram_addrs_counter <= 'b0;
            end
            SET_CURSOR_AND_WRITE: begin
                case(create_char_task)
                    SET_CURSOR: begin
                        rs <= 0; data <= (cgram_addrs_counter > 2)? 8'h80 + (cgram_addrs_counter%3) + 8'h40 : 8'h80 + (cgram_addrs_counter%3);
                        create_char_task <= WRITE_LCD; 
                    end
                    WRITE_LCD: begin
                        rs <= 1; data <=  8'h00 + cgram_addrs_counter;
                        if(cgram_addrs_counter == num_cgram_addrs-1)begin
                            cgram_addrs_counter = 'b0;
                            done_lcd_write <= 1'b1;
                        end else begin
                            cgram_addrs_counter <= cgram_addrs_counter + 1;
                        end
                        create_char_task <= SET_CURSOR; 
                    end
                endcase
            end
            WRITE_EXTRA_TEXT: begin
				    done_lcd_write <= 1'b0;
				    current = next1;
                case(current)
                    // Escribir "NH:" en la posición POS_NH
                    0: begin
                        rs <= 0;
                        data <= POS_NH ;  // Posición para "NH:"
                        next1 <= 1;
	
                    end
                    1: begin
                        rs <= 1;
                        data <= "N";  // 'N'
								next1 <= 2;
                       
                    end
                    2: begin
                        rs <= 1;
                        data <= "H";  // 'H'
                        next1 <= 3;

                    end
                    3: begin
                        rs <= 1;
                        data <= ":";  // ':'
                        next1 <= 4;
                    end
                    4: begin
                        rs <= 1;
                        data <= dec_hambre;  // Valor decimal del nivel de hambre
                        next1 <= 5;
                    end
						 
                    // Escribir "ND:" en la posición POS_ND
                    5: begin
                        rs <= 0;
                        data <= POS_ND;  // Posición para "ND:"
                        next1 <= 6;
                    end
                    6: begin
                        rs <= 1;
                        data <= "N";  // 'N'
                        next1 <= 7;
								
                    end
                    7: begin
                        rs <= 1;
                        data <= "D";  // 'D'
                        next1 <= 8;
								
                    end
                    8: begin
                        rs <= 1;
                        data <= ":";  // ':'
                        next1 <= 9;
								
                    end
                    9: begin
                        rs <= 1;
                        data <= dec_diversion;  // Valor decimal del nivel de diversión
                        next1 <= 10;  // Volver al inicio
								
							end
						  10: begin
                        rs <= 1;
                        data <= " ";  // Valor decimal del nivel de diversión
                        next1 <= 0;  // Volver al inicio
								done_lcd_write <= 1'b1;
                     end
                endcase					 
            end
        endcase
    end
end

assign enable = clk_16ms;
assign done_cgram_write = (data_counter == 48-1)? 'b1 : 'b0;  // Usar 48 ya que cada bloque tiene 48 filas

endmodule