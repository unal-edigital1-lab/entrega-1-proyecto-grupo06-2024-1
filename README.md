# Especificación de Diseño del Proyecto Tamagotchi en FPGA

## 1. Introducción

### 1.1 Objetivo
El objetivo del proyecto es desarrollar un sistema de Tamagotchi en FPGA (Field-Programmable Gate Array) que simule el cuidado de una mascota virtual. Esto se logrará mediante una lógica de estados que refleje las necesidades y condiciones de la mascota, junto con mecanismos de interacción a través de botones y sensores.

### 1.2 Delimitaciones
El proyecto se centrará en la creación de un sistema básico de Tamagotchi, que incluirá una interfaz de usuario operada mediante botones físicos, al menos un sensor para ampliar las formas de interacción y un sistema de visualización para representar el estado actual y las necesidades de la mascota virtual. Se utilizará la FPGA Cyclone IV con restricciones claras en términos de recursos de hardware disponibles, y la implementación se detallará en Verilog.

## 2. Descripción General del Sistema

### 2.1 Contexto del Sistema
El sistema Tamagotchi en FPGA es concebido como un sistema autónomo destinado a emular la experiencia de mantener y cuidar una mascota virtual. Se fundamenta en el uso de máquinas de estado algorítmico para gestionar las diversas condiciones y comportamientos de la mascota.

### 2.2 Funcionalidad Principal
El sistema simulará interactivamente el cuidado de una mascota virtual, permitiendo al usuario participar en actividades esenciales como alimentar, jugar, dormir y curar, a través de una interfaz visual y botones y sensores.

## 3. Especificaciones del Sistema

### 3.1 Sistema de Botones
#### 3.1.1 Botones 
- Reset: Reestablece el Tamagotchi a un estado inicial conocido.
- Test: Activa el modo de prueba.
- Boton de  alimentar:  Modifica los estados de  hambriento y salud  
- Boton de  Jugar: Modifica los estados de diversión, descansar y feliz 
- Acelerador de Tiempo: Permite modificar la velocidad del tiempo en el Tamagotchi.

### 3.2 Sistema de Sensado

Se implementarán tres sensores para enriquecer la interacción del usuario con el Tamagotchi:

1. **Codificador Propio (Simulación de Biberón):** Este sensor generará una señal determinada que se sincronizará con el sistema, actuando como un biberón virtual. Cuando el usuario interactúe con este sensor, se modificará el estado del Tamagotchi de "Hambriento", indicando que ha sido alimentado.

2. **Sensor de Ultrasonido:** Utilizado para la detección de proximidad y movimiento. Cuando se detecte proximidad cercana, el Tamagotchi será activado de un estado de Descansar, simulando el despertar por la presencia del usuario.

3. **Sensor Infrarrojo:** Cuando el sensor detecta la presencia de señales infrarrojas, simularía que el usuario está acariciando o interactuando de manera amistosa con el Tamagotchi. Esta interacción podría modificar el estado "Feliz" del Tamagotchi.

Estos sensores proporcionarán una experiencia de usuario más inmersiva y dinámica, permitiendo una mayor variedad de interacciones con el Tamagotchi y enriqueciendo la simulación del cuidado de la mascota virtual.



### 3.3 Sistema de Visualización
Se utilizará un Display LCD de 16x2 basado en el controlador HD44780 para mostrar información detallada sobre el estado actual del Tamagotchi, como texto descriptivo y mensajes de estado. Además, se aprovecharán los display de 7 segmentos incorporados en la FPGA para mostrar niveles específicos, como el nivel de hambre o felicidad, complementando la visualización principal del LCD.

## 4. Arquitectura del Sistema

### 4.1 Diagramas de Bloques
Se incluirá un diagrama para los botones, la pantalla, sensores (codificador propio, ultrasonido, infrerrojo) y estados etc.


#### Sensor Ultrasonido Hc-sr04

Con este programa enviamos pulsos periódicos de 10 microsegundos por el pin TRIGGER del sensor para activarlo. Una vez activado, el pin ECHO se pone a "1", comenzando a medir el tiempo desde que se envía un tren de 8 pulsos de eco hacia el exterior hasta que dicho tren de ondas de sonido vuelve a llegar al sensor. En ese momento, el pin ECHO vuelve a ponerse a "0". Durante el tiempo en que ECHO está activa en ALTO, dos contadores de 8 bits almacenan el número de microsegundos transcurridos y envían este valor al script en formato decimal y para realizar la conversión a distancia en milímetros.

Si la velocidad del sonido (Vsonido) es de 340 m/s, la fórmula para calcular la distancia (en mm) es: distancia (mm) = 0.17 x tiempo (microsegundos).


El bloque de código dispone de:

**Entradas**
- `clk`: Señal de reloj para sincronizar las operaciones del módulo.
- `ECHO`: s la señal de eco que se recibe del sensor de ultrasonido, que indica la duración del eco del pulso ultrasónico.

**Salidas**
-  `Trigger` es la señal de activación que se envía al sensor de ultrasonido para iniciar la medición.
-  `ECHO` que se conecta a la salida ECHO del sensor.
-   `Out`: [15:0] de 16 bits por donde se envía al exterior la lectura de los dos contadores de microsegundos.
- `done`, que envía un TIC cuando el sensor ha terminado de realizar la medición.




#### Infrarojo TCRT5000



#### LCD I2C

**Entradas**
1. `clk`: Señal de reloj para sincronizar las operaciones del módulo.
2. `rst`: Señal de reinicio para restablecer el estado del módulo.
3. `sda`: Línea de datos de la interfaz I2C.
4. `scl`: Línea de reloj de la interfaz I2C.
5. `data`: Datos a enviar al LCD.
6. `enable`: Señal de habilitación para iniciar la transmisión de datos al LCD.
7. `rs`: Señal de selección de registro para el LCD (0 = instrucción, 1 = datos).
   
**Salidas**
1. `busy`: Indica si el controlador está ocupado realizando una operación.





### 4.2 Descripción de Componentes
- FPGA: Corazón del sistema que ejecuta la lógica del Tamagotchi.
- Pantalla: Muestra el estado actual del Tamagotchi.
- Botones: Permiten al usuario interactuar con la mascota.
- Sensor: Detecta estímulos externos para modificar el comportamiento del Tamagotchi.

### 4.3 Interfaces
- Comunicación entre la FPGA y la pantalla.
- Entradas digitales para los botones.
- Comunicación entre la FPGA y el sensor.

## 5. Especificaciones de Diseño Detalladas

### 5.1 Modos de operación

#### 5.1.1 Modo Test
- Permite validar la funcionalidad del sistema y sus estados.
- Activación: Manteniendo pulsado el botón "Test" durante 5 segundos.
- Funcionalidad: Permite la navegación manual entre los estados del Tamagotchi.

#### 5.1.2 Modo Normal
- Modo estándar de operación del Tamagotchi.
- Activación: Arranca por defecto tras el encendido o reinicio.
- Funcionalidad: Los usuarios interactúan con la mascota para satisfacer sus necesidades básicas.

#### 5.1.3 Modo Aceleración 
- Incrementa la velocidad a la que transcurren los eventos y el tiempo.
- Activación: Pulsando el botón dedicado a "Aceleración de Tiempo".
- Funcionalidad: Todos los eventos operan a una velocidad incrementada.

### 5.2 Estados 

#### 5.2.1 Estados Mínimos
- Hambriento
- Diversión
- Descansar
- Salud
- Feliz
- Triste
- Aburrido


El proyecto Tamagotchi en FPGA ofrecerá una experiencia interactiva que simula el cuidado de una mascota virtual, aprovechando la capacidad de la FPGA para gestionar estados, interacciones y visualización de manera eficiente.