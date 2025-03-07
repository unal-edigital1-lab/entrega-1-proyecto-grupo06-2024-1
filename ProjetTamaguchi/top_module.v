module top_module (
    input wire clk,                  // Reloj del sistema
    input wire reset_n,              // Reset negado (activo bajo)
    input wire test_n,               // Botón test negado (activo bajo)
    input wire alimentar_n,          // Botón de alimentar negado
    input wire jugar_n,              // Botón de jugar negado
    input wire ultrasonido_ech,      // Señal de echo del sensor de ultrasonido
    input wire ruido_input,          // Señal de entrada del sensor de ruido (KY-037)
	 output wire [2:0] nivel_hambre,  // Nivel de hambre (1 a 5)
    output wire[2:0] nivel_diversion, // Nivel de diversión (1 a 5)
    output wire [2:0] estado_tamagotchi, // Estado actual del Tamagotchi
    output wire trigger_ultrasonido, // Señal de trigger para el sensor de ultrasonido
    output wire rs_lcd,              // Señal RS para la pantalla LCD
    output wire rw_lcd,              // Señal RW para la pantalla LCD
    output wire enable_lcd,          // Señal Enable para la pantalla LCD
    output wire [7:0] data_lcd,      // Datos para la pantalla LCD
    output wire ruido_detectado,    // Señal de detección de ruido
    output wire object_detected 
	 
);

    
    wire reset_db, test_db;           // Señales debounced de reset y test
    
    

    // Instancia del módulo niveles (hambre/diversión)
    niveles niveles_inst (
        .clk(clk),
        .alimentar(alimentar_n),         // Botón alimentar
        .jugar(jugar_n),                 // Botón jugar
        .reset(reset_n),                 // Reset global
        .test(test_n),                   // Test global
        .nivel_hambre(nivel_hambre),     // Nivel de hambre
        .nivel_diversion(nivel_diversion), // Nivel de diversión
        .reset_debounced(reset_db),      // Reset con antirrebote
        .test_debounced(test_db)         // Test con antirrebote
    );

    // Instancia del módulo fms_estados (máquina de estados)
    fms_estados fms_estados_inst (
        .clk(clk),
        .reset_n(reset_n),               // Reset negado
        .test_n(test_n),                 // Test negado
        .hambre(nivel_hambre),           // Nivel de hambre (de 'niveles')
        .diversion(nivel_diversion),     // Nivel de diversión (de 'niveles')
        .ultrasonido_n(~object_detected),// Sensor de ultrasonido (negado)
        .ruido_n(~ruido_detectado),      // Sensor de ruido (negado)
        .estado(estado_tamagotchi)       // Estado del Tamagotchi
    );

    // Instancia del sensor ultrasonido
    Ultrasonic_Sensor ultrasonic_sensor_inst (
        .clk(clk),
        .ech(ultrasonido_ech),           // Señal "echo" del sensor ultrasonido
        .trigger_o(trigger_ultrasonido), // Señal de trigger
        .object_detected(object_detected) // Detección de objeto
    );

    // Instancia del sensor de ruido
    sensor_sonido sensor_sonido_inst (
        .clk(clk),
        .sensor_input(ruido_input),      // Entrada del sensor KY-037
        .ruido_detectado(ruido_detectado) // Salida: detección de ruido
    );

    LCD1602_cust_char lcd_inst (
        .clk(clk),
        .reset(reset_n),                 // Reset global
        .ready_i(1'b1),                  // Asumimos que siempre está listo
        .control_signal(estado_tamagotchi), // Estado Tamagotchi como señal de control
		  .nivel_hambre(nivel_hambre),
		  .nivel_diversion(nivel_diversion),
        .rs(rs_lcd),                     // Señal RS para el LCD
        .rw(rw_lcd),                     // Señal RW para el LCD
        .enable(enable_lcd),             // Señal Enable para el LCD
        .data(data_lcd) // Datos para el LCD
    );

endmodule