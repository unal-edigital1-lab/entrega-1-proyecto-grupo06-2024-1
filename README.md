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


1. 2. **Sensor de Sonido**: Utilizado para la deteccion de algun ruido y asi verificar la presencia del cuidador de modo que nuestro compañero asi no nos entienda, sepa que tiene a alguien presente







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
![Diagrama de bloques dig drawio (1)](https://github.com/user-attachments/assets/8d51b7ec-5bcd-482a-b93b-e4b28ff2c0fc)




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



## Describir modulos