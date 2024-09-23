# Especificación de Diseño del Proyecto Tamagotchi en FPGA

* Duván Felipe Pacheco Rodriguez
* Jaime Andrés Martín Moreno
* Jairo David Luna Díaz

## 1. Introducción
El presente informe detalla el diseño e implementación de un sistema de Tamagotchi en una FPGA (Field-Programmable Gate Array), utilizando la FPGA Cyclone IV y el lenguaje de descripción de hardware Verilog. El objetivo del proyecto es emular la experiencia de cuidar una mascota virtual, integrando una lógica de estados que refleje sus necesidades y condiciones, así como mecanismos de interacción a través de botones físicos y sensores. Este enfoque permite explorar la programación y el diseño de sistemas digitales en un entorno práctico y dinámico, proporcionando una base sólida para comprender los principios de la electrónica digital y el diseño de hardware.

El sistema de Tamagotchi incluye varios estados, tales como energia, salud, hambre, entretenimiento y un estado de felicidad general usando pulsadores, la deteccion de proximidad para marcar una interaccion determinada o la estimulacion por sonido de modo que altera los estados del Tamagotchi. Estas caracteristicas permiten una interaccion realista con la mascota virtual fomentando una experiencia unica, tan unica que usando una pantalla lcd 20 04  puede ver con buena definicios las posturas de nuestro querido amigo y tener idea de el estado en que se encuentra por expresiones faciales o emoticonos.




### 1.1 Objetivo
El objetivo del proyecto es desarrollar un sistema de Tamagotchi en FPGA (Field-Programmable Gate Array) que simule el cuidado de una mascota virtual. Esto se logrará mediante una lógica de estados que refleje las necesidades y condiciones de la mascota, junto con mecanismos de interacción a través de botones y sensores.

### 1.2 Delimitaciones
El proyecto se centrará en la creación de un sistema básico de Tamagotchi, que incluirá una interfaz de usuario operada mediante botones físicos, al menos un sensor para ampliar las formas de interacción y un sistema de visualización para representar el estado actual y las necesidades de la mascota virtual. Se utilizará la FPGA Cyclone IV con restricciones claras en términos de recursos de hardware disponibles, y la implementación se detallará en Verilog.

## 2. Descripción General del Sistema

### 2.1 Contexto del Sistema
El sistema Tamagotchi en FPGA es concebido como un sistema autónomo destinado a emular la experiencia de mantener y cuidar una mascota virtual. Se fundamenta en el uso de máquinas de estado algorítmico para gestionar las diversas condiciones y comportamientos de la mascota.

### 2.2 Funcionalidad Principal
El sistema simulará interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales como alimentar, descansar y jugar a través de una interfaz visual , botones y sensores.

## 3. Especificaciones del Sistema

### 3.1 Sistema de Botones
#### 3.1.1 Botones 
- Reset: Reestablece el Tamagotchi a un estado inicial conocido.
- Alimentar: Permite subir el nivel de hambre
- Jugar: Permite subir el nivel de diversion
  
  


### 3.2 Sistema de Sensado

Se implementarán tres sensores para enriquecer la interacción del usuario con el Tamagotchi:


1. **Sensor de Ultrasonido:** Utilizado para la detección de proximidad y movimiento. Cuando se detecte proximidad cercana, el Tamagotchi será activado de un estado de Descansar, simulando el despertar por la presencia del usuario.




<p align="center">
 
<img src="https://github.com/user-attachments/assets/3a458edc-7881-47e1-9489-590a3ce574a6" title="[Sensor de Ultrasonido]" width="600" height="450">
<div align="center">Sensor de Ultrasonido.</div>
 
</p>


 2. **Sensor de Sonido**: Utilizado para la deteccion de algun ruido y asi verificar la presencia del cuidador de modo que nuestro compañero asi no nos entienda, sepa que tiene a alguien presente


<p align="center">
 
<img src="https://github.com/user-attachments/assets/be1f637c-4a96-49f4-ab26-aff26a97b7d5" title="[Sensor de sonido]" width="600" height="450">
<div align="center">Sensor de Sonido.</div>
 
</p>






Estos sensores proporcionarán una experiencia de usuario más inmersiva y dinámica, permitiendo una mayor variedad de interacciones con el Tamagotchi y enriqueciendo la simulación del cuidado de la mascota virtual.



### 3.3 Sistema de Visualización
Se utilizará una pantalla LCD de 2004 basada en el controlador HD44780 para mostrar información detallada sobre el estado actual del Tamagotchi, incluyendo texto descriptivo y mensajes de estado. Además, esta misma pantalla se aprovechará para representar gráficamente las expresiones faciales del Tamagotchi, reflejando su estado de ánimo.

<p align="center">
 
<img src="https://github.com/user-attachments/assets/6cfd2368-ccab-46f5-a52e-c1f6bd197a02" title="[pantalla LCD de 20x4]" width="600" height="450">
<div align="center">Pantalla LCD de 20x4.</div>
 
</p>


## 4. Arquitectura del Sistema

### 4.1 Diagramas de Bloques
Se incluirá un diagrama general para los botones, la pantalla, sensores ( ultrasonido y Infrarrojo). 

![Diagrama de bloques dig drawio (2)](https://github.com/user-attachments/assets/a18a6139-82e4-4ea1-b2f1-a32fefd08c46)


### 4.2 Descripción de Componentes
- FPGA: Corazón del sistema que ejecuta la lógica del Tamagotchi.
- Pantalla LCD 20x4: Muestra el estado actual del Tamagotchi.
- Botones: Permiten al usuario interactuar con la mascota.
- Sensor Ultrasonido y Sonoro: Detecta estímulos externos para modificar el comportamiento del Tamagotchi.


### 4.3 Interfaces
- Comunicación entre la FPGA y la pantalla.
- Entradas digitales para los botones.
- Comunicación entre la FPGA y el sensor.

## 5. Especificaciones de Diseño Detalladas



### 5.1 Estados 

#### 5.1.1 Estados basicos



- **Neutro** Inicial
- **Feliz** Esta Satisfecho
- **Triste** Si alguno de los dos niveles esta en un estado no optimo (NH o ND)
- **Cansado** Depende de la presencia de ruido o proximidad
- **Hambriento** El nivel de hambre es alto
- **Muerto** Murio de hambre



#### 5.2.2 Sistema de Niveles y Logica de Estados:
Para crear un sistema de niveles o puntuación que refleje la calidad del cuidado proporcionado al Tamagotchi, podemos definir una serie de estados y niveles asociados a los parámetros de hambre, salud, diversion y descanso. Cada parámetro fluctuará en una escala del 1 al 5, donde:

1 y 5 representa un nivel extremo, sea maximo o minimo
2 y 4 un nivel critico, sea optimo o no optimo
3 un nivel intermendio estable

A continuación, se detallan las reglas para gestionar estos estados y niveles.

##### Sistema de Niveles y Estados:

###### Niveles
- **Nivel de Hambre (NH):** 1 a 5
- **Nivel de Diversion (ND):** 1 a 5

###### Reglas de transición de estados

La una máquina de estados que controla el comportamiento de un tamagotchi basado en los niveles de hambre, diversión, y sensores (ultrasonido y ruido). Los estados están definidos en 3 bits, con las siguientes transiciones:

1. **Estado inicial:**
   - Al iniciar (reset), el estado es `NEUTRO`.

2. **Modo Test:**
   - Si el botón de test (`test_n`) está presionado durante más de 5 segundos, la máquina entra en "modo test". En este modo, la máquina de estados sigue una secuencia fija:
     - `NEUTRO` → `FELIZ` → `TRISTE` → `CANSADO` → `HAMBRIENTO` → `MUERTO` → `NEUTRO`.

3. **Transiciones normales:**
   - Las transiciones dependen de los niveles de hambre, diversión y los sensores de ultrasonido y ruido. 

##### Reglas de transición por estado:

1. **NEUTRO:**
   - Si el nivel de **hambre** es mayor o igual a 4 → **HAMBRIENTO**.
   - Si el nivel de **diversión** es mayor o igual a 4 y el hambre es menor o igual a 2 → **FELIZ**.
   - Si el nivel de **diversión** es menor o igual a 2 o el hambre es mayor o igual a 4 → **TRISTE**.
   - Si alguno de los sensores (ultrasonido o ruido) detecta presencia o ruido → **CANSADO**.
   - Si ninguna de las condiciones anteriores se cumple → permanece en **NEUTRO**.

2. **FELIZ:**
   - Si el nivel de **hambre** es mayor o igual a 3 o la **diversión** baja de 4 → **NEUTRO**.
   - Si ninguna de estas condiciones se cumple → permanece en **FELIZ**.

3. **TRISTE:**
   - Si el nivel de **hambre** es menor a 4 y la **diversión** es mayor a 2 → **NEUTRO**.
   - Si no se cumplen las condiciones → permanece en **TRISTE**.

4. **CANSADO:**
   - Si los sensores de **ultrasonido** y **ruido** no detectan presencia ni ruido → **NEUTRO**.
   - Si el nivel de **hambre** es 5 y la **diversión** es 1 → **MUERTO**.
   - Si ninguna de las condiciones anteriores se cumple → permanece en **CANSADO**.

5. **HAMBRIENTO:**
   - Si el nivel de **hambre** es menor a 4 → **NEUTRO**.
   - Si el nivel de **hambre** es 5 y la **diversión** es 1 → **MUERTO**.
   - Si ninguna de estas condiciones se cumple → permanece en **HAMBRIENTO**.

6. **MUERTO:**
   - Permanece en **MUERTO**, no hay retorno desde este estado.

### Tabla de Estados y Transiciones

| Estado Actual | Condición para Cambiar             | Estado Siguiente |
|---------------|------------------------------------|------------------|
| **NEUTRO**    | Hambre >= 4                        | HAMBRIENTO       |
|               | Diversión >= 4, Hambre <= 2        | FELIZ            |
|               | Diversión <= 2 o Hambre >= 4       | TRISTE           |
|               | Ultrasonido o Ruido activado       | CANSADO          |
|               | Ninguna                            | NEUTRO           |
| **FELIZ**     | Hambre >= 3 o Diversión < 4        | NEUTRO           |
|               | Ninguna                            | FELIZ            |
| **TRISTE**    | Hambre < 4 y Diversión > 2         | NEUTRO           |
|               | Ninguna                            | TRISTE           |
| **CANSADO**   | Ultrasonido y Ruido desactivados   | NEUTRO           |
|               | Hambre == 5 y Diversión == 1       | MUERTO           |
|               | Ninguna                            | CANSADO          |
| **HAMBRIENTO**| Hambre < 4                         | NEUTRO           |
|               | Hambre == 5 y Diversión == 1       | MUERTO           |
|               | Ninguna                            | HAMBRIENTO       |
| **MUERTO**    | Ninguna                            | MUERTO           |

  



#### 5.2.3 Control de Niveles

El módulo `niveles` simula la dinámica de un tamagotchi, controlando dos aspectos clave: **hambre** y **diversión**, ambos representados con valores entre 1 y 5. Estos niveles cambian dependiendo de la interacción del usuario y el paso del tiempo.

### Concepto básico:

1. **Interacción del usuario:**
   - El usuario puede **alimentar** o **jugar** con el tamagotchi usando botones.
   - Cada vez que el usuario presiona el botón de **alimentar**, el nivel de hambre disminuye (si es mayor que 1), lo que representa que el tamagotchi está menos hambriento.
   - Si el usuario presiona el botón de **jugar**, el nivel de diversión aumenta (si es menor que 5), indicando que el tamagotchi está más entretenido.

2. **Efecto del tiempo:**
   - El tiempo se mide en minutos, utilizando un contador que genera una señal cada minuto.
   - Con el paso del tiempo, el **nivel de hambre aumenta** gradualmente (hasta un máximo de 5), lo que simula que el tamagotchi se va poniendo más hambriento si no se alimenta.
   - Al mismo tiempo, el **nivel de diversión disminuye** (hasta un mínimo de 1), lo que refleja que el tamagotchi se aburre si no juegan con él.

### Detalles técnicos:

- **Antirrebote de botones:** Se usa una técnica de filtrado (antirrebote) para evitar que señales no deseadas de los botones afecten los niveles. Esto asegura que cada interacción con los botones sea estable y no cause fluctuaciones erráticas.

- **Botones:**
  - `alimentar`: Reduce el nivel de hambre.
  - `jugar`: Aumenta el nivel de diversión.
  - `reset`: Reinicia los niveles a sus valores iniciales (hambre en 1 y diversión en 5).
  - `test`: Usado para pruebas, aunque en este módulo no parece tener un uso directo.

- **Inicialización:** Al inicio, el nivel de hambre está en 1 (mínimo) y el nivel de diversión en 5 (máximo). Estos niveles cambian con el tiempo o la interacción del usuario.

### Ciclo de comportamiento:

- **Si no hay interacción:**
  - Cada minuto que pasa, el **nivel de hambre sube** y el **nivel de diversión baja**.

- **Si hay interacción:**
  - Si se presiona **alimentar**, el nivel de hambre baja.
  - Si se presiona **jugar**, el nivel de diversión sube.
  
### Ejemplo de comportamiento:

- Al inicio, el tamagotchi está **poco hambriento** (nivel de hambre = 1) y **muy entretenido** (nivel de diversión = 5).
- Si pasa un minuto sin alimentar, el nivel de hambre sube a 2, y la diversión baja a 4.
- Si el usuario juega con el tamagotchi, la diversión sube a 5 nuevamente.
- Si se sigue sin alimentar, el hambre sigue subiendo gradualmente hasta un máximo de 5.



###### Diagrama máquina de Estados


![mermaid-ai-diagram-2024-09-22-220132](https://github.com/user-attachments/assets/196ff1fc-933b-4b84-85ec-07aa9e540be4)



### 6.Plan de trabajo.

| **Semana** | **Objetivos**                                                                                      | **Tareas**                                                                                                              |
|------------|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| **1**      | Planificación y Diseño Inicial                                                                     | - Reunión inicial: definir alcance y roles.                                                                             |
|            |                                                                                                    | - Especificación del sistema: desarrollar y finalizar el diagrama de bloques, especificar componentes principales.      |
|            |                                                                                                    | - Diseño de la máquina de estados: crear el diagrama, definir estados y reglas de transición.                           |
|            |                                                                                                    | - Investigación y adquisición de componentes: seleccionar y pedir componentes necesarios.                               |
| **2**      | Implementación de Subcomponentes                                                                   | **Visualización**                                                                                                       |
|            |                                                                                                    | - Implementación del módulo de pantalla LCD: desarrollar el módulo en Verilog, especificar funciones para mostrar texto y gráficos. |
|            |                                                                                                    | - Pruebas unitarias de la pantalla LCD: realizar pruebas y documentar resultados.                                       |
|            |                                                                                                    | **Sistema de Sensado**                                                                                                  |
|            |                                                                                                    | - Implementación del módulo de sensor de ultrasonido: desarrollar el módulo en Verilog, especificar funcionalidad.      |
|            |                                                                                                    | - Implementación del módulo de sensor sonido: desarrollar el módulo en Verilog, especificar funcionalidad.          |
|            |                                                                                                    | - Pruebas unitarias de los sensores: realizar pruebas y documentar resultados.                                          |
|            |                                                                                                    | **Máquina de Estados en Verilog**                                                                                       |
|            |                                                                                                    | - Implementación de la máquina de estados: desarrollar la máquina de estados en Verilog, implementar transiciones.      |
|            |                                                                                                    | - Pruebas unitarias de la máquina de estados: realizar pruebas y documentar resultados.                                 |
| **3**      | Integración y Pruebas del Sistema Completo                                                         | - Integración de subcomponentes: integrar módulos de pantalla LCD, sensores y máquina de estados.                       |
|            |                                                                                                    | - Pruebas integradas: realizar pruebas del sistema completo, identificar y corregir errores.                            |
|            |                                                                                                    | - Desarrollo del firmware: implementar firmware para interacción con sensores y pantalla LCD, probar y ajustar.         |
|            |                                                                                                    | - Documentación técnica: documentar proceso de integración y pruebas realizadas, actualizar documentación del proyecto. |
| **4**      | Optimización y Documentación Final                                                                 | - Optimización del sistema: optimizar código Verilog, realizar pruebas de rendimiento y ajustar según sea necesario.    |
|            |                                                                                                    | - Pruebas finales: realizar pruebas finales para asegurar cumplimiento de requisitos, verificar funcionalidad en escenarios diversos. |
|            |                                                                                                    | - Preparación del informe final: redactar informe final, incluir detalles de diseño, implementación y pruebas.          |
|            |                                                                                                    | - Presentación del proyecto: preparar y practicar presentación del proyecto.                                            |



## 7.Descripción de hardware en Verilog

Se puede describir el funcionamiento del proyecto en base a seis módulos principales, los cuales procesan información desde el exterior (entnendiendo como exterior los sensores o la FPGA) y comunican dicho procesamiento entre sí y el exterior. Cada uno se encuentra un archivo independiente de verilog, y son los siguientes: "*Ultrasonic_Sensor.v*", "*sensor_sonido.v*", "*fms_estados.v*", "*niveles.v*", "*LCD1602_cust_char.v*" y "*top_module.v*"

### 7.1 Modulo de Ultrasonido (*Ultrasonic_Sensor.v*)

```verilog
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

```
Este módulo en Verilog controla un sensor ultrasónico que mide la distancia a un objeto usando pulsos de sonido generados por el sensor, que luego evalúa el tiempo de retardo de la respuesta del rebote de la perturbación del sonido. Así pues, la distancia se mide en términos de retardo temporal, por lo que se hace necesario calcular el tiempo que tarda el eco en regresar por medio del código de verilog, teniendo como otro parámetro parcial la distancia, y usar este valor para influenciar en los estados de la máquina del proyecto.

A continuación, se explica el funcionamiento del módul línea por línea, función por función, y se describe su integración con otros módulos.

```verilog
module Ultrasonic_Sensor ( 
    input wire clk,           // Señal de reloj
    input wire ech,           // Señal del pulso "echo"
    output reg trigger_o,     // Señal de activación del "trigger"
    output reg object_detected // Salida que indica si se detectó un objeto
);
```
Se declaran dos entradas y dos salidas con "input" y "output": se necesita para describir el exterior dos señales, que por ser variantes en el tiempo se declaran como "wire", pudiendo obtener así valores de "1" o "0". Estas dos corresponden a lo que detecta el sensor de ultrasonido con su salida digital (HIGH, LOW) y los pulsos de reloj de la FPGA. Por el lado de las salidas, se necesita generar pulsos de activación que reciba el pin de "trigger" en el ultrasonido, y guardar la información de que en efecto hay un objeto en la cercanía, sabido por los cálculos hechos en el código, de forma que ambos se declaran como registros "reg".

```verilog
// Parámetros para el cálculo de tiempo
parameter CLOCK_FREQ = 50000000; // Frecuencia del reloj en Hz (ej. 50MHz)
parameter SOUND_SPEED = 34300;   // Velocidad del sonido en cm/s
parameter DISTANCE_THRESHOLD = 10; // Umbral de 10 cm
```
Estos parámetros se usan en el código, pues son constantes que conocemos de antemano y de las cuales dependemos para hacer los cálculos necesarios de distancia en función del tiempo de retardo del echo: sabemos que la frecuencia de reloj es de 50 MHz, que la velocidad del sonido en condiciones atomsféricas comunes es de 34300 cm/s, y ya, por decisión nuestra, que se considerará que el sistema "habrá detectado un objeto en la cercanía" si está a 10cm o menos de distancia. Se trabajan en estas unidades por ser de fácil manipulación: segundos, por estar directamente relacionado con el funcionamiento de la FPGA, y centímetros por ser una unidad de distancia apropiada para los rangos de proximidad que buscamos detectar.

```verilog
parameter TIME_THRESHOLD = (4 * DISTANCE_THRESHOLD * CLOCK_FREQ) / SOUND_SPEED;
```

Se crea otro parámetro derivado de los anteriores tres llamado "tiempo límite", que corresponde al tiempo máximo en ciclos de reloj para detectar el eco. Destaca en el cálculo que hay una constante de proporcionalidad "4": se debe a que el tiempo de ida y vuelta del sonido se multiplica por 2, y hay un factor de 2 más debido a la conversión de distancia a tiempo, de forma que es para una correción del tiempo de medición.

```verilog
reg [31:0] echo_time; // Contador de tiempo para el pulso "echo"
reg measuring;        // Bandera que indica si estamos midiendo el tiempo
reg [23:0] trigger_count; // Contador para el tiempo de activación del trigger
reg [31:0] delay_count;   // Contador para el retraso entre triggers
```
Se declaran, además de los anteriores cuatro parámetros de tamaños diferentes determinada por su función particular, procurando que no sean más grandes de lo necesario. "echo_time" servirá para almacenar el tiempo del eco, "measuring" indicará si se está midiendo el tiempo de pulso del eco (es, pues, una variable auxiliar), "trigger_count" almacenará como contador la duración del pulso del trigger para el ultrasonido y "delay_count" será otro contador para gestionar el tiempo de espera entre los pulsos del trigger.

```verilog
initial begin
    echo_time = 0;
    measuring = 0;
    trigger_o = 0;
    trigger_count = 0;
    delay_count = 0;
end
```
El anterior bloque únicamente inicializa todo en cero, a fin de comenzar los cálculos apropiadamente y sin basura en la memoria. Ahora bien, después de todo esto, por fin se puede inicializar el bloque cíclico dependiente del pulso de reloj:

```verilog
always @(posedge clk) begin
```

```verilog
    if (trigger_count > 0) begin
        trigger_count <= trigger_count - 1;
        trigger_o <= 1;
    end else begin
        trigger_o <= 0;
    end
```

La funcionalidad de este bloque es la siguiente: se mantiene activo el pulso del trigger durante el tiempo definido en los parámetros. De esa forma, durante este tiempo el "wire" de trigger se mantiene encendido en "1", y esto ocurrirá hasta que el contador del tiempo de duración llegue a "0", indicando que se debe apagar.

```verilog
    if (measuring) begin
        if (ech) begin
            echo_time <= echo_time + 1;
        end else begin
            measuring <= 0;
            if (echo_time < TIME_THRESHOLD) begin
                object_detected <= 1;
            end else begin
                object_detected <= 0;
            end
            echo_time <= 0;
        end
```
Este siguiente bloque se ejecuta cuando se comience a medir el tiempo de eco (el tiempo de retorno). La variable "ech" se mantiene cierta (1) siempre y cuando no haya retornado, por lo que va a incrementar el contador de "echo_time". Ahora bien, tan pronto se apague, será el paso de medir si, en efecto, durante ese tiempo detecto algún elemento en la cercanía en base al valor de distancia planteado. Si sí, entonces retornará el output de "object_detected", y caso contrario lo dejará en apagado.

```verilog
    end else begin
        delay_count <= delay_count + 1;
        if (delay_count >= CLOCK_FREQ/10) begin
            delay_count <= 0;
            trigger_count <= 10;
            measuring <= 1;
        end
    end
endmodule

```
El módulo concluye con este último bloque, en donde se mide el delay de forma que se pueda activar el trigger nuevamente si se llega a un décimo del ciclo de reloj.

### 7.2 Modulo de Sonido (*sensor_sonido.v*)

```verilog
module sensor_sonido(
    input wire clk,          // Reloj de la FPGA
    input wire sensor_input, // Entrada del sensor KY-037 (DO)
    output reg ruido_detectado // Salida: 1 si detecta ruido, 0 si no
);

    always @(posedge clk) begin
        // Simplemente se asigna el valor del sensor a la salida
        if (sensor_input == 1) begin
            ruido_detectado <= 1; // Detecta ruido
        end else begin
            ruido_detectado <= 0; // No detecta ruido
        end
    end

endmodule
```

El módulo sensor_sonido.v es un código en Verilog que interpreta las señales de un sensor de sonido KY-037 y comunica el estado de detección de ruido a la FPGA. 

```verilog
module sensor_sonido(
    input wire clk,          // Reloj de la FPGA
    input wire sensor_input, // Entrada del sensor KY-037 (DO)
    output reg ruido_detectado // Salida: 1 si detecta ruido, 0 si no
);
```
"module" define el inicio del módulo en Verilog a referenciarse en el top como "sensor_sonido". Se definen, luego, dos entradas y una salida por medio de las declaraciones "input" y "output": 

1.Dado que hay dos señales que se propagan hasta el módulo desde afuera que son necesarias los cambios de estado, las cuales son el reloj que viene desde la FPGA y las excitaciones del sensor de sonido mismo, se determina que sean de tipo "wire", sin necesidad de almacenar ningún valor y con cambio dinámico constante.

2.Por otro lado, se declara un registro "reg" para "ruido_detectado", porque necesita mantener su valor en función del estado de "sensor_input" en el flanco positivo del reloj. Cada vez que cambia "sensor_input", "ruido_detectado" se actualiza y mantiene ese valor hasta el próximo evento de reloj, permitiendo que haya consistencia entre los ciclos de reloj y represente apropiadamente la parte secuencial del sistema. 

```verilog
always @(posedge clk) begin
```

Se inicializa un bloque que se ejecuta de forma cíclica en cada flanco ascendente del reloj. Se puede interpretar como que la FPGA se actualiza y cambia sus estado interno cada vez que se da un pulso de reloj (que es cada vez que se ejecuta este bloque).

Dentro de dicho bloque "always" se ve ahora:

```verilog
    if (sensor_input == 1) begin
        ruido_detectado <= 1; // Detecta ruido
    end else begin
        ruido_detectado <= 0; // No detecta ruido
    end
```

Se puede interpretar este proceso de la siguiente manera: si el sensor, ya por su funcionamiento interno, está excitado, sabemos que va a mandar una señal HIGH desde su pin de salida DIGITAL si está alimentado. Al recibirla la FPGA, y al haberse declarado la entrada con el código, estando asociadas, entonces identifica esta señal HIGH (caso igual a 1), y así también lo hará si es LOW (en caso igual a 0). Dado este valor, se almacena en el registro, que se usará en otro módulo para tomar decisiones con respecto a los cambios de estado del Tamagotchi.

```verilog
end
endmodule
```

Finalizando en bloque, y el módulo, se puede reducir este módulo en descripción de la siguiente forma: "dependiendo de las excitaciones del sensor de sonidos, que se den cambios en un registro que identificará cómo debe operarse en la máquina de estados finitos"

### 7.3 Modulo de Maquina de estados (*fms_estados.v*)

```verilog
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
```

### 7.4 Modulo de Niveles (*niveles.v*)
-Objetivo del codigo: De acuerdo a los inputs de pulsadores retornar los registros de 3 bits de niveles necesarios en la maquina de estados.
-Implementacion del codigo: 
Parametros: Parámetros Definidos:
  CLK_FREQ = 50000000;   // Frecuencia del reloj en Hz (50 MHz por ejemplo)
  SEGUNDOS_EN_MINUTO = 25;

Inicialmente este modulo recibe los inputs de los pulsadores e implementa un antirrebote de 3 bits, para evitar errores en la pulsacion.
Para los niveles consta de dos registros de 3 bits, hambre y diversion con estados default de 0 y 5 respectivamente, siguen la logica descrita en el apartado 5.1.1 donde varian de acuerdo al pulsador y a el tiempo transcurrido propuesto (1 minuto) contando los ciclos y almacenandolos en el registro de 32 bits contador_reloj.



Modulo de LCD Custom Char


MÓDULO S

