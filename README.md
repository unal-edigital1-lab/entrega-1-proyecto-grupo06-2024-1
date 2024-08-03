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


### 3.2 Sistema de Sensado

Se implementarán tres sensores para enriquecer la interacción del usuario con el Tamagotchi:


1. **Sensor de Ultrasonido:** Utilizado para la detección de proximidad y movimiento. Cuando se detecte proximidad cercana, el Tamagotchi será activado de un estado de Descansar, simulando el despertar por la presencia del usuario.


<p align="center">
 
<img src="https://github.com/user-attachments/assets/3a458edc-7881-47e1-9489-590a3ce574a6" title="[Sensor de Ultrasonido]" width="600" height="450">
<div align="center">Sensor de Ultrasonido.</div>
 
</p>


1. **Sensor Infrarrojo:** Cuando el sensor detecta la presencia de señales infrarrojas, simularía que el usuario está acariciando o interactuando de manera amistosa con el Tamagotchi. Esta interacción podría modificar el estado "Feliz" del Tamagotchi.




<p align="center">
 
<img src="https://github.com/user-attachments/assets/b2f5df48-0b7d-4c47-bbfe-c58a38a07ec0" title="[Infrarrojo]" width="600" height="450">
<div align="center">Sensor Infrarrojo.</div>
 
</p>


Estos sensores proporcionarán una experiencia de usuario más inmersiva y dinámica, permitiendo una mayor variedad de interacciones con el Tamagotchi y enriqueciendo la simulación del cuidado de la mascota virtual.



### 3.3 Sistema de Visualización
Se utilizará una pantalla LCD de 20x4 basada en el controlador HD44780 para mostrar información detallada sobre el estado actual del Tamagotchi, incluyendo texto descriptivo y mensajes de estado. Además, esta misma pantalla se aprovechará para representar gráficamente las expresiones faciales del Tamagotchi, reflejando su estado de ánimo.

<p align="center">
 
<img src="https://github.com/user-attachments/assets/6cfd2368-ccab-46f5-a52e-c1f6bd197a02" title="[pantalla LCD de 20x4]" width="600" height="450">
<div align="center">Pantalla LCD de 20x4.</div>
 
</p>


## 4. Arquitectura del Sistema

### 4.1 Diagramas de Bloques
Se incluirá un diagrama general para los botones, la pantalla, sensores ( ultrasonido y Infrarrojo). 
![Diagrama de bloques dig drawio (1)](https://github.com/user-attachments/assets/8d51b7ec-5bcd-482a-b93b-e4b28ff2c0fc)



### 4.2 Descripción de Componentes
- FPGA: Corazón del sistema que ejecuta la lógica del Tamagotchi.
- Pantalla LCD 20x4: Muestra el estado actual del Tamagotchi.
- Botones: Permiten al usuario interactuar con la mascota.
- Sensor Ultrasonido e Infrarrojo: Detecta estímulos externos para modificar el comportamiento del Tamagotchi.


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

#### 5.2.1 Estados 

- **Hambriento:** Representa el estado del Tamagotchi cuando tiene hambre.
- **Diversión:**  Representa el estado en el que el Tamagotchi está siendo entretenido.
- **Descansar:**  Representa cuando el Tamagotchi se está tomando un descanso.
- **Salud:**  Indica un estado saludable basado en una combinación de NH y NF.
- **Feliz:**  Representa cuando el Tamagotchi está completamente feliz.
- **Triste:**  Representa un estado de tristeza.


#### 5.2.2 Sistema de Niveles o Puntos:
Para crear un sistema de niveles o puntuación que refleje la calidad del cuidado proporcionado al Tamagotchi, podemos definir una serie de estados y niveles asociados a los parámetros de hambre y felicidad. Cada parámetro fluctuará en una escala del 1 al 5, donde 1 representa una necesidad urgente de atención y 5 representa un estado óptimo. A continuación, se detallan las reglas para gestionar estos estados y niveles.

##### Sistema de Niveles y Estados:

###### Niveles
- **Nivel de Hambre (NH):** 1 a 5
- **Nivel de Felicidad (NF):** 1 a 5
- **x**: Distancia del ultrasonido en cm


###### Estados
- **Hambriento:** NH = 1
- **Diversión:** NF ≥ 4 y infrarrojo = 1
- **Descansar:** Si x > 100 cm y infrarrojo = 1 y activado por tiempo sin interacción.
- **Salud:** Derivado de una combinación de NH y NF.
- **Feliz:** NF = 5 y NH ≥ 3 y Si x  < 100
- **Triste:** NF ≤ 2 o NH = 1

###### Reglas de Transición de Estados

1. **Hambriento:**
   - Permanece en Hambriento si NH == 1.
   - Cambia a Salud si NH >= 3 y NF >= 3.
   - Cambia a Feliz si NF == 5 y NH >= 3 y x < 100.
   - Cambia a Triste si NF <= 2 o NH == 1.
   - Cambia a Diversion si NF >= 4 y infrarrojo == 1 y NH >= 2.
  
  
2. **Diversión:**
   - Permanece en Diversion si NF >= 4 y infrarrojo == 1 y NH >= 2.
   - Cambia a Feliz si NF == 5 y NH >= 3 y x < 100.
   - Cambia a Triste si NF <= 2 o NH == 1.
   - Cambia a Salud si NH >= 3 y NF >= 3.
   - Cambia a Hambriento si NH == 1.
  
3. **Descansar:**
   - Permanece en Descansar si x > 100 y infrarrojo == 1 y no_interaccion.
   - Cambia a Hambriento si NH == 1.
   - Cambia a Triste si NF <= 2 o NH == 1.
   - Cambia a Diversion si NF >= 4 y infrarrojo == 1 y NH >= 2.
   - Cambia a Salud si NH >= 3 y NF >= 3.
   - Cambia a Feliz si NF == 5 y NH >= 3 y x < 100.

4. **Salud:**
   - Permanece en Salud si NH >= 3 y NF >= 3.
   - Cambia a Hambriento si NH == 1.
   - Cambia a Triste si NF <= 2 o NH == 1.
   - Cambia a Diversion si NF >= 4 y infrarrojo == 1 y NH >= 2.
   - Cambia a Feliz si NF == 5 y NH >= 3 y x < 100.Cambia a Descansar si x > 100 y infrarrojo == 1 y no_interaccion.

5. **Feliz:**
   - Permanece en Feliz si NF == 5 y NH >= 3 y x < 100.
   - Cambia a Hambriento si NH == 1.
   - Cambia a Triste si NF <= 2 o NH == 1.
   - Cambia a Diversion si NF >= 4 y infrarrojo == 1 y NH >= 2.
   - Cambia a Salud si NH >= 3 y NF >= 3.
   - Cambia a Descansar si x > 100 y infrarrojo == 1 y no_interaccion.
  
6. **Triste:**
   - Permanece en Triste si NF <= 2 o NH == 1.
   - Cambia a Hambriento si NH == 1.
   - Cambia a Diversion si NF >= 4 y infrarrojo == 1 y NH >= 2.
   - Cambia a Salud si NH >= 3 y NF >= 3.
   - Cambia a Feliz si NF == 5 y NH >= 3 y x < 100.
   - Cambia a Descansar si x > 100 y infrarrojo == 1 y no_interaccion.


###### Diagrama máquina de Estados

![mermaid-ai-diagram-2024-08-03-193602](https://github.com/user-attachments/assets/a701b292-eb6f-418c-9d1b-92b543dc7da1)

