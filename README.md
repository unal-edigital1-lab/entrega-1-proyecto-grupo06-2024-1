# Especificación de Diseño del Proyecto Tamagotchi en FPGA

* Duván Felipe Pacheco Rodriguez
* Jaime Andrés Martín Moreno
* Jairo David Luna Díaz

## 1. Introducción
El presente informe detalla el diseño e implementación de un sistema de Tamagotchi en una FPGA (Field-Programmable Gate Array), utilizando la FPGA Cyclone IV y el lenguaje de descripción de hardware Verilog. El objetivo del proyecto es emular la experiencia de cuidar una mascota virtual, integrando una lógica de estados que refleje sus necesidades y condiciones, así como mecanismos de interacción a través de botones físicos y sensores. Este enfoque permite explorar la programación y el diseño de sistemas digitales en un entorno práctico y dinámico, proporcionando una base sólida para comprender los principios de la electrónica digital y el diseño de hardware.

El sistema de Tamagotchi incluye varios estados, tales como energia, salud, hambre, entretenimiento y un estado de felicidad general, todo esto usando pulsadores, la deteccion de proximidad para marcar una interaccion determinada por patrones o la estimulacion por sonido de modo que altera los estados del Tamagotchi. Estas caracteristicas permiten una interaccion realista con la mascota virtual fomentando una experiencia unica, tan unica que usando una pantalla lcd (xx*x) puede ver con buena definicios las posturas de nuestro querido amigo y tener idea de el estado en que se encuentra por expresiones faciales o emoticonos.




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
- Sting: Este boton permite la curacion del Tatmagochi y restaurar la salud
- Food: Este boton permite la alimentacion de nuestro amigo
- Acc: Este boton permite la aceleracion del sistema a 30x, lo que hace que 1 segundo equivalga a 30 segundos
  


### 3.2 Sistema de Sensado

Se implementarán tres sensores para enriquecer la interacción del usuario con el Tamagotchi:


1. **Sensor de Ultrasonido:** Utilizado para la detección de proximidad y movimiento. Cuando se detecte proximidad cercana, el Tamagotchi será activado de un estado de Descansar, simulando el despertar por la presencia del usuario.




<p align="center">
 
<img src="https://github.com/user-attachments/assets/3a458edc-7881-47e1-9489-590a3ce574a6" title="[Sensor de Ultrasonido]" width="600" height="450">
<div align="center">Sensor de Ultrasonido.</div>
 
</p>


1. 2. **Sensor de Sonido**: Utilizado para la deteccion de algun ruido y asi verificar la presencia del cuidador de modo que nuestro compañero asi no nos entienda, sepa que tiene a alguien presente


TOCA CAMBIAR LA FOTO XD

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
TOCA CORREGIR ESTO


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

### 5.1 Modos de operación

#### 5.1.1 Modo Test
- Permite validar la funcionalidad del sistema y sus estados.
- Activación: Manteniendo pulsado el botón "Test" durante 5 segundos.
- Funcionalidad: Permite la navegación manual entre los estados del Tamagotchi.
  NO SE COMO USAR EL TEST; SERIA BUENO POR UNOS PINES DIGITALES ASI COMO CON LA LCD

#### 5.1.2 Modo Normal
- Modo estándar de operación del Tamagotchi.
- Activación: Arranca por defecto tras el encendido o reinicio.
- Funcionalidad: Los usuarios interactúan con la mascota para satisfacer sus necesidades básicas.

#### 5.1.3 Modo Aceleración 
- Incrementa la velocidad a la que transcurren los eventos y el tiempo.
- Activación: Pulsando el botón dedicado a "Aceleración de Tiempo".
- Funcionalidad: Transiciona entre estados a una aceleracion x30 de modo que la mayoria de estados se podran ver en un tiempo menor a 2 minutos

### 5.2 Estados 

#### 5.2.1 Estados 



- **Hambre:** Representa el estado del Tamagotchi cuando tiene hambre y se omite cuando esta lleno.
- **Salud:**  Representa el estado del Tamagotchi cuando esta enfermo y se omite cuando esta sano.
- **Diversión:**  Representa el estado del Tamagotchi cuando esta aburrido y se omite cuando esta estimulado y divertido
- **Descansar:** Representa el estado del Tamagotchi cuando esta cansado de tanto jugar y se omite cuando esta descansado
- **Feliz:**  Representa cuando el Tamagotchi está completamente feliz, implica que todos los problemas han sido solucionados y nuestro amiguito no puede pedir nada mas para hacer mejor su vida.



#### 5.2.2 Sistema de Niveles o Puntos:
Para crear un sistema de niveles o puntuación que refleje la calidad del cuidado proporcionado al Tamagotchi, podemos definir una serie de estados y niveles asociados a los parámetros de hambre, salud, diversion y descanso. Cada parámetro fluctuará en una escala del 1 al 5, donde:

1 representa una necesidad urgente y critica de atención 
2 representa una necesidad urgente 
3 representa un estado aceptable aunque pronto requerira atencion
4 representa un estado bueno
5 representa un estado óptimo, no se puede mejorar mas, esta completamente saciado. 

A continuación, se detallan las reglas para gestionar estos estados y niveles.

##### Sistema de Niveles y Estados:

###### Niveles
- **Nivel de Hambre (NH):** 1 a 5
- **Nivel de Salud (NS):** 1 a 5
- **Nivel de Felicidad(Diversion) (NF):** 1 a 5
- **Nivel de Energia (NE):** 1 a 5


###### Estados
- **Hambriento:** NH <= 2
- **Lleno:** NH >= 3
- **Enfermo:** NS ==1
- **Saludable:** NS >= 2
- **Aburrido:** NF <= 2
- **Entretenido:** NF >= 3
- **Cansado:** NE <= 2
- **Pleno:** NE >= 3
- **Feliz:** Implica que como todos son secuenciales, entonces al estar pleno, las demas necesidades han sido saciadas y por ende es el mismo estado a **Pleno** ya que todo esta a un nivel optimo o bueno

###### Reglas de Transición de Estados

1. **Hambriento:**
   - Permanece en Hambriento si NH <= 2.
   - Sale del estado Hambriento si NH >= 3 (en teoria llega a un estado lleno y evalua el estado de salud)
  
2. **Salud:**
  - Permanece en Enfermo si NS <= 1.
  - Sale del estado Enfermo si NS >= 2 (en teoria llega a un estado sano y evalua el estado de diversion)
  
3. **Diversión:**
  - Permanece en Aburrido si NF <= 2.
  - Sale del estado Aburrido si NF >= 3 (en teoria llega a un estado de entretenido y evalua el estado de energia)

4. **Energia:**
  - Permanece en Cansado si NE <= 2.
  - Sale del estado Cansado si NE >= 3 (en teoria llega a un estado de entretenido y estaria en estado Feliz)
   
6. **Feliz:**
   - Es el mejor estado en que puede estar, no tiene hambre , ni enfermo, ni anda aburrido y anda con buena energia, asi que anda muy feliz porque anda saciado y agradecido al dueño


#### 5.2.3 Control

Hay dos modulos independientes que transforman las lecturas de los sensores a entradas binarias para que la maquina de estados actue

El del sensor de ultrasonido transforma la distancia en un bit de salida de acuerdo a lo que se implemente
ACA LA IDEA MIA ES QUE SEA 1 SI SE CUMPLE UN PATRON, ESTILO ALEJAR Y ACERCAR LA MANO SIMULANDO GOLPECITOS TIERNOS  O ALGO ASI; O SI NO HAY TIEMPO SOLO QUE DETECTE 1 SI ESTA A UNA DISTANCA CERCANA

El del sensor de sonido si detecta un umbral de ruido , tiene una salida de 1 


Por otro lado, la maquina de control funciona de esta forma:

1. **Hambriento:**
   - Si Food == 1 por 10 segundos, NH += 1
   - Transcurridos 30 minutos, NH -= 1 ya que le da hambre con el tiempo
  
2. **Salud:**
  - Si Sting == 1 por 3 segundos, NS += 1
  - Transcurridos 60 minutos, NS -= 1 ya que xd, se enferma si no se cuida con el tiempo
  
3. **Diversión:**
  - Si d == 1 por 30 segundos, NF += 1 aunque solo podra hacer esto 2 veces, solo se puede incrementar NF por esta via dos veces
  - Si sound == 1 por 150 segundos, NF += 1 aunque solo podra hacer esto 2 veces, solo se puede incrementar NF por esta via dos veces
  - Transcurridos 15 minutos, NF -= 1 ya que le da hambre con el tiempo

4. **Energia:**
  - Si d o sound se usan mas de 30 segundos, NE -=1 ya que al jugar con el, se cansa
  - Transcurridos 15 minutos, NE += 1 ya que al no hacer nada, descansa y se restaura la energia



###### Diagrama máquina de Estados

![mermaid-ai-diagram-2024-08-03-193602](https://github.com/user-attachments/assets/a701b292-eb6f-418c-9d1b-92b543dc7da1)
TOCA CORREGIR ESTO


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
