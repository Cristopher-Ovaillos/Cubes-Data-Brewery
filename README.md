# GUIA instalacion de Cubes
Tener una zona de trabajo, abrir la terminal de VSCODE y ejecutar en esa ubicacion lo siguiente: 

```bash
git clone https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery.git

cd Cubes-Data-Brewery
```

## Índice

- [Que es CUBES](#que-es-cubes)
- [Archivos a descargar e instalar](#archivos-a-descargar-e-instalar)
- [Recursos y Documentación de Cubes OLAP](#recursos-y-documentación-de-cubes-olap)
- [Python 3.6.7](#python-367)
- [PASO 1: DB BROWSER SQLITE](#paso-1-db-browser-sqlite)
- [PASO 2: Entorno Virtual Python](#paso-2-entorno-virtual-python)
- [PASO 3: Crear el MODELO del Cubo](#paso-3-crear-el-modelo-del-cubo)
- [PASO 4: Crear el Archivo de Configuración](#paso-4-crear-el-archivo-de-configuración)
- [PASO 5: CubesViewer-Intefaz grafica](#paso-5-cubesviewer-intefaz-grafica)


---
## Que es CUBES

Cubes (DataBrewery) es un framework OLAP escrito en Python diseñado para facilitar el análisis multidimensional de datos.

Funciona creando una capa lógica sobre las tablas relacionales: en lugar de escribir SQL complejo cada vez, se definen cubos con dimensiones (por ejemplo producto, cliente, tiempo), niveles (año → mes → día) y medidas (suma de ventas, cantidad). Esa capa lógica usa mappings para saber qué columna real de la base de datos corresponde a cada nombre lógico, de modo que las consultas se escriben en términos comprensibles y Cubes traduce todo a SQL o al backend correspondiente.

Ofrece además un servidor HTTP/REST que permite pedir agregados, listar miembros de dimensiones, obtener hechos o ejecutar reportes desde aplicaciones y dashboards.

Ventajas principales:

- simplifica y estandariza consultas analíticas.
- permite cambiar la estructura física (tablas/columnas) sin reescribir los análisis.
- soporta drill-down/roll-up automático en jerarquías.
- es integrable con visualizadores y herramientas web.

Es especialmente útil para equipos que necesitan hacer análisis periódicos o exploratorios sobre datos almacenados en bases relacionales, porque acelera la creación de reportes y reduce errores al centralizar la lógica de negocio en el modelo del cubo.


## Archivos a descargar e instalar
   - [Python 3.6.7 (OBLIGATORIO: Click ADD-PATCH (Si aparece la opcion, al ejecutar el instalador))](https://drive.google.com/file/d/1wiY7CqwMDopTY8XzxT3vQo3_xUZXJxQT/view?usp=sharing)
   - [DB Browser SQLite](https://drive.google.com/file/d/1uRXYI_d7vVpHZctN9U-4mfLAg-72DVP5/view?usp=sharing)

## Recursos y Documentación de Cubes OLAP

### Documentación Oficial de Cubes

- **Guía de Configuración**  
  [Configuración de Cubes 1.0.1](https://cubes.readthedocs.io/en/v1.0.1/configuration.html)  
  Explica cómo configurar tu proyecto, definir los orígenes de datos (*stores*), los modelos de cubos y las conexiones a la base de datos.

- **Herramienta de Línea de Comandos `slicer`**  
  [Comandos de Slicer — Cubes 1.0.1](https://cubes.readthedocs.io/en/v1.0.1/slicer.html)  
  Detalla cómo levantar el servidor OLAP, validar modelos, generar SQL (`DDL`) y ejecutar pruebas desde la terminal.

- **Servidor OLAP / API HTTP**  
  [Servidor Cubes — Documentación](https://pythonhosted.org/cubes/server.html)  
  Describe cómo exponer tus cubos vía API JSON para integrarlos con front-end, dashboards o visualizadores como CubesViewer.

### Repositorios de Ejemplos y Modelos

- **Modelos Básicos de Cubos**  
  [cubes-models](https://github.com/DataBrewery/cubes)  
  Colección de modelos predefinidos de cubos y dimensiones, útil como plantilla para nuevos proyectos.

- **Proyectos de Ejemplo y Demostraciones**  
  [cubes-examples](https://github.com/DataBrewery/cubes-examples)  
  Ejemplos prácticos con datos de prueba, archivos de configuración (`slicer.ini`, `model.json`) y scripts listos para probar Cubes rápidamente.

---

> Esto sirve para levantar tu servidor OLAP, probar queries y entender operaciones OLAP como `slice`, `dice`, `drill-down` y `roll-up` en un entorno real.

## Python 3.6.7
*Notas:*
- *Python al ser de uso comun, uno puede presentar la version actualizada es por eso debemos setear de alguna manera a esta version de Python (3.6.7)*.
- *Usar VSCODE (comodidad para trabajar y hacer uso de la terminal).*

```bash
# Listar versiones instaladas
py --list
# -V:3.6-32        Python 3.6 (32-bit)

# Setear version
py -3.6 

# verificar version actual
python --version

```
> Si los comandos no devuelven nada reiniciar VSCODE, si el error persiste este puede deberse al PATH-(Ver Tutorial)https://youtu.be/5iS4273i1Rs.





---
## PASO 1: DB BROWSER SQLITE
### Esto ya esta incluido en el repo. pero es para que vean como trabajar y crear TABLAS/POBLAR con otros dominio.
- Crear una carpeta data.
- Abrir DB browser (SQLITE).
- Crear una base de datos `ventas`.
- Crear tablas y poblar.
- Guardar cambios

Imagenes
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_2.png)
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_3.png)

Ingresar el SQL de crear tablas y de poblar. Ejecutar cada una.

![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_4.png)

Guardar Cambios.

![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_5.png)

Veremos lo siguiente.
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_6.png)

**Crear tablas**

```sql
-- Crear tablas
CREATE TABLE productos (
    producto_id INTEGER PRIMARY KEY,
    nombre TEXT,
    categoria TEXT,
    subcategoria TEXT
);

CREATE TABLE clientes (
    cliente_id INTEGER PRIMARY KEY,
    nombre TEXT,
    ciudad TEXT,
    pais TEXT
);

CREATE TABLE tiempo (
    fecha_id INTEGER PRIMARY KEY,
    fecha TEXT,
    anio INTEGER,
    mes INTEGER,
    trimestre INTEGER
);

CREATE TABLE ventas (
    venta_id INTEGER PRIMARY KEY,
    producto_id INTEGER,
    cliente_id INTEGER,
    fecha_id INTEGER,
    cantidad INTEGER,
    precio_unitario REAL,
    monto_total REAL,
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (fecha_id) REFERENCES tiempo(fecha_id)
);

```
**Poblar tablas**

```sql
-- Productos
INSERT INTO productos (producto_id, nombre, categoria, subcategoria) VALUES
(1, 'Laptop Dell', 'Electrónica', 'Computadoras'),
(2, 'Mouse Logitech', 'Electrónica', 'Accesorios'),
(3, 'Teclado Mecánico', 'Electrónica', 'Accesorios'),
(4, 'Monitor Samsung', 'Electrónica', 'Monitores'),
(5, 'Silla Ergonómica', 'Muebles', 'Oficina');

-- Clientes
INSERT INTO clientes (cliente_id, nombre, ciudad, pais) VALUES
(1, 'Juan Pérez', 'Buenos Aires', 'Argentina'),
(2, 'María García', 'Neuquén', 'Argentina'),
(3, 'Carlos López', 'Santiago', 'Chile'),
(4, 'Ana Martínez', 'Lima', 'Perú'),
(5, 'Luis Fernández', 'Montevideo', 'Uruguay');

-- Tiempo
INSERT INTO tiempo (fecha_id, fecha, anio, mes, trimestre) VALUES
(1, '2024-01-15', 2024, 1, 1),
(2, '2024-02-20', 2024, 2, 1),
(3, '2024-03-10', 2024, 3, 1),
(4, '2024-04-05', 2024, 4, 2),
(5, '2024-05-22', 2024, 5, 2),
(6, '2024-06-18', 2024, 6, 2),
(7, '2024-07-30', 2024, 7, 3),
(8, '2024-08-12', 2024, 8, 3),
(9, '2024-09-25', 2024, 9, 3),
(10, '2024-10-08', 2024, 10, 4);

-- Ventas
INSERT INTO ventas (venta_id, producto_id, cliente_id, fecha_id, cantidad, precio_unitario, monto_total) VALUES
(1, 1, 1, 1, 2, 1200.00, 2400.00),
(2, 2, 2, 2, 5, 25.00, 125.00),
(3, 3, 3, 3, 3, 80.00, 240.00),
(4, 4, 1, 4, 1, 450.00, 450.00),
(5, 5, 2, 5, 2, 300.00, 600.00),
(6, 1, 4, 6, 1, 1200.00, 1200.00),
(7, 2, 5, 7, 10, 25.00, 250.00),
(8, 3, 3, 8, 4, 80.00, 320.00),
(9, 4, 2, 9, 2, 450.00, 900.00),
(10, 5, 1, 10, 1, 300.00, 300.00),
(11, 1, 3, 1, 3, 1200.00, 3600.00),
(12, 2, 4, 3, 8, 25.00, 200.00),
(13, 3, 5, 5, 2, 80.00, 160.00),
(14, 4, 1, 7, 1, 450.00, 450.00),
(15, 5, 2, 9, 3, 300.00, 900.00);

```
---
## PASO 2: Entorno Virtual Python
*En nuestro projecto mismo, ingresar los siguientes comandos en orden.*
```bash
# Crear un entorno virtual 
python -m venv cubes_env

# Activar el entorno virtual
.\cubes_env\Scripts\activate 
#puedo desactivarlo ingresando en la terminal "deactivate"
```
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_1-1.png)


**Dentro del entorno Virtual creado anteriormente**
```bash
# Instalar versiones específicas que funcionan juntas 
pip install cubes==1.1  
pip install sqlalchemy==1.3.24
pip install flask==1.1.4
pip install werkzeug==1.0.1
pip install jsonschema==3.2.0
pip install flask-cors
#fin instalacion :D
```

**IMPORTANTE**: Estas versiones son compatibles entre sí. NO instales otras versiones.

>**python -m venv cubes_env**   Es utilizado para crear un entorno virtual. Es un Python aislado, que permite instalar paquetes especificos sin afectar Python global. Entonces, cada projecto puede tener sus propias versiones de librerias. Si queremos tener otros projectos, esto nos evitara conflictos entre ellos (ej. si otro projecto necesita tal version de SQLACHEMY no habra problemas), MENTENEMOS EL SISTEMA LIMPIO.

>**cubes==1.1** Es el Framework OLAP que vamos a usar. Este lo que hace es traducir consultas dimensiones que serian los famosos cubes a SQL.

>**sqlalchemy==1.3.24** Cubes fue desarrollado alrededor de la API de SQLEALCHEMY. 

>**flask==1.1.4** Microframework web en Python. Cubes lo usa para servir el servidor OLAP vía HTTP.

>**werkzeug==1.0.1** Librería que Flask necesita internamente para manejar rutas, requests y responses.

>**jsonschema==3.2.0** Valida archivos JSON según un esquema definido. Cubes lo usa para validar modelos, dimensiones y cubos definidos en JSON.

>**flask-cors** Es una extensión para Flask que maneja CORS (Cross-Origin Resource Sharing). CORS es un mecanismo de seguridad en los navegadores que bloquea solicitudes entre dominios diferentes por defecto. Plantemos lo siguiente, Si nuestro servidor Flask (por ejemplo, Cubes OLAP) corre en localhost:5000 y querés acceder a él desde otra web o desde una aplicación JavaScript en localhost:5500, el navegador bloqueará la petición sin CORS. Entoces con esto permitimos configurar quien puede acceder al servidor y evitar errores de cross-origin Request Blocked que sucedia sin esto.
---

## PASO 3: Crear el MODELO del Cubo
Mas info. 
https://pythonhosted.org/cubes/model.html

Describiremos los datos desde el modelo logico desde la perspeciva del usuario: Datos como se miden, agregan y reportan. El modelo es `INDEPENDIENTE` de la implementacion fisica de datos. Esto independencia hace que sea facil concentrarse en los datos en lugar de en las formas de obtener los datos. 

```json
{
    "cubes": [
        {
            "name": "ventas",
            "dimensions": ["producto", "cliente", "tiempo"],
            "measures": [
                {
                    "name": "cantidad",
                    "label": "Cantidad"
                },
                {
                    "name": "monto_total",
                    "label": "Monto Total"
                }
            ],
            "aggregates": [
                {
                    "name": "cantidad_sum",
                    "label": "Suma de Cantidad",
                    "function": "sum",
                    "measure": "cantidad"
                },
                {
                    "name": "monto_sum",
                    "label": "Suma de Monto",
                    "function": "sum",
                    "measure": "monto_total"
                },
                {
                    "name": "monto_avg",
                    "label": "Promedio de Monto",
                    "function": "avg",
                    "measure": "monto_total"
                },
                {
                    "name": "cantidad_ventas",
                    "label": "Cantidad de Ventas",
                    "function": "count"
                }
            ],
            "mappings": {
                "producto.producto_id": "productos.producto_id",
                "producto.nombre": "productos.nombre",
                "producto.categoria": "productos.categoria",
                "producto.subcategoria": "productos.subcategoria",
                "cliente.cliente_id": "clientes.cliente_id",
                "cliente.nombre": "clientes.nombre",
                "cliente.ciudad": "clientes.ciudad",
                "cliente.pais": "clientes.pais",
                "tiempo.fecha_id": "tiempo.fecha_id",
                "tiempo.fecha": "tiempo.fecha",
                "tiempo.anio": "tiempo.anio",
                "tiempo.mes": "tiempo.mes",
                "tiempo.trimestre": "tiempo.trimestre"
            },
            "joins": [
                {
                    "master": "ventas.producto_id",
                    "detail": "productos.producto_id"
                },
                {
                    "master": "ventas.cliente_id",
                    "detail": "clientes.cliente_id"
                },
                {
                    "master": "ventas.fecha_id",
                    "detail": "tiempo.fecha_id"
                }
            ]
        }
    ],
    "dimensions": [
        {
            "name": "producto",
            "label": "Producto",
            "levels": [
                {
                    "name": "categoria",
                    "label": "Categoría",
                    "attributes": ["categoria"]
                },
                {
                    "name": "subcategoria",
                    "label": "Subcategoría",
                    "attributes": ["subcategoria"]
                },
                {
                    "name": "producto",
                    "label": "Producto",
                    "attributes": ["producto_id", "nombre"],
                    "key": "producto_id",
                    "label_attribute": "nombre"
                }
            ],
            "hierarchies": [
                {
                    "name": "default",
                    "levels": ["categoria", "subcategoria", "producto"]
                }
            ]
        },
        {
            "name": "cliente",
            "label": "Cliente",
            "levels": [
                {
                    "name": "pais",
                    "label": "País",
                    "attributes": ["pais"]
                },
                {
                    "name": "ciudad",
                    "label": "Ciudad",
                    "attributes": ["ciudad"]
                },
                {
                    "name": "cliente",
                    "label": "Cliente",
                    "attributes": ["cliente_id", "nombre"],
                    "key": "cliente_id",
                    "label_attribute": "nombre"
                }
            ],
            "hierarchies": [
                {
                    "name": "default",
                    "levels": ["pais", "ciudad", "cliente"]
                }
            ]
        },
        {
            "name": "tiempo",
            "label": "Tiempo",
            "levels": [
                {
                    "name": "anio",
                    "label": "Año",
                    "attributes": ["anio"]
                },
                {
                    "name": "trimestre",
                    "label": "Trimestre",
                    "attributes": ["trimestre"]
                },
                {
                    "name": "mes",
                    "label": "Mes",
                    "attributes": ["mes"]
                },
                {
                    "name": "fecha",
                    "label": "Fecha",
                    "attributes": ["fecha_id", "fecha"],
                    "key": "fecha_id",
                    "label_attribute": "fecha"
                }
            ],
            "hierarchies": [
                {
                    "name": "default",
                    "levels": ["anio", "trimestre", "mes", "fecha"]
                }
            ]
        }
    ]
}
```

DATOS:
- CUBES: `ventas` que usa las dimensiones producto, cliente y tiempo. Dentro ademas definimos las medidas, agregados y mapeos asi como los join para unir las tabla de hechos con las dimensiones. 
- MEASURES: `cantidad` y `monto_total`.
- AGGREGATES: `cantidad_sum`, `monto_sum`, `monto_avg` y `cantidad_ventas`.
- mappings: El nombre lógico es cómo vos querés llamar a un dato dentro de Cubes.
  - El nombre físico es cómo se llama realmente en la base de datos.
  - El mapping conecta ambos para que Cubes pueda traducir tus consultas a SQL sin que tengas que preocuparte por los nombres reales.
*En este caso en mi DB se llaman igual asi que no hay problema.*

## PASO 4: Crear el Archivo de Configuración

4.1 Crear un archivo `slicer.ini` (en mi caso slicer esta dentro de una carpeta dentro de mi zona de trabajo, por eso puse `data/`).

```ini
[workspace]
model = data/modelo.json

[store]
type = sql
url = sqlite:///data/ventas.db
schema = main

[server]
host = localhost
port = 5000
reload = yes
log_level = info

[models]
main = data/modelo.json   
```
4.2 Iniciar el servidor `slicer.ini` (estar en la ubicacion del archivo-acordarse y dentro del entorno).

[Info para saber que es SLICER y que hacer si queremos usar otra base de datos.](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/docs/slicer.md)




```bash
slicer serve .\data\slicer.ini
```


![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_7.png)

**Visualizamos el link de exito, ingresamos: http://localhost:5000/.**

En esta terminal podemos visualizar las peticiones que hacemos al servidor.

Observaremos si esas peticiones son exitosas o no.

Recordar codigos HTTPs `200` `400`,etc.

Al ingresar http://localhost:5000/ sale lo siguiente para que se entienda:
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_8.png)
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_9.png).

podemos probar las siguientes consultas (estas se hacen por URL, se puede probar por el navegador y recibiremos .json como respuesta).

**GUIA CONSULTAS-SINTAXIS**
[info consultas](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/docs/querys.md)

### Información del Cubo
```bash
http://localhost:5000/cube/ventas/model
```
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_10.png).

### Agregación Simple (Total de ventas)
```bash
http://localhost:5000/cube/ventas/aggregate
```
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_11.png).

### Filtrar por País y Año
```bash
http://localhost:5000/cube/ventas/aggregate?cut=cliente.pais:Argentina|tiempo.anio:2024
```
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_12.png)

La consulta realizada al cubo `ventas` solicitó un resumen de los datos correspondientes únicamente a las ventas de clientes en **Argentina** durante el **año 2024**. La respuesta incluye los siguientes elementos:

- **summary**: contiene los principales indicadores agregados del cubo.  
  - `cantidad_sum`: suma de unidades vendidas → 17  
  - `monto_sum`: monto total facturado → 6125  
  - `monto_avg`: promedio por venta → 765,625  
  - `cantidad_ventas`: número de transacciones → 8  

- **cell**: indica la celda del cubo a la que corresponden los datos, es decir, el **filtro aplicado**.  
  - Cliente: `Argentina`  
  - Año: `2024`  

- **aggregates**: lista de los agregados calculados en la consulta, por ejemplo:  
  - `cantidad_sum`, `monto_sum`, `monto_avg`, `cantidad_ventas`  

- **remainder** y **attributes**: aparecen vacíos en esta consulta porque no se aplicó desagregación adicional ni se solicitaron atributos específicos.

Esta información permite obtener un panorama general de las ventas bajo los filtros aplicados y sirve como base para generar reportes, gráficos o análisis más detallados modificando los criterios de filtrado.

### Agregación por Categoría de Producto
```bash
http://localhost:5000/cube/ventas/aggregate?drilldown=producto:categoria
```

### Agregación por País
```bash
http://localhost:5000/cube/ventas/aggregate?drilldown=cliente:pais
```

### Agregación por Año y Trimestre
```bash
http://localhost:5000/cube/ventas/aggregate?drilldown=tiempo:anio|tiempo:trimestre
```

### Filtrar por Categoría
```bash
http://localhost:5000/cube/ventas/aggregate?cut=producto.categoria:Electrónica
```

### Múltiples Dimensiones
```bash
http://localhost:5000/cube/ventas/aggregate?drilldown=producto:categoria|cliente:pais
```

### Ordenar Resultados
```bash
http://localhost:5000/cube/ventas/aggregate?drilldown=producto:categoria&order=monto_sum:desc
```

### Listar Hechos Individuales (Facts)
```bash
http://localhost:5000/cube/ventas/facts
```

## PASO 5: CubesViewer-Intefaz grafica

http://www.cubesviewer.com/#/features

La pagina tiene ejemplos para visualizar el poder de este visualizador.
http://www.cubesviewer.com/studio.html 

Lo que vamos a hacer, es nuestra zona de trabajo 
```bash
    Directorio: C:\Users\Cristopher-Ovaillos\Desktop\Cubes-Project\Cubes-Data-Brewery


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        09/11/2025      8:09                cubes_env
d-----        09/11/2025      8:56                data
d-----        09/11/2025      9:51                docs
d-----        09/11/2025      9:28                img
-a----        09/11/2025      7:20             14 .gitignore
-a----        09/11/2025      9:50          21596 README.md
```

Use lo siguiente: 
https://github.com/jjmontesl/cubesviewer/blob/master/doc/guide/cubesviewer-quickstart.md

Para guiar y utilizar este visualizador.
- Ingresar el siguiente comando para descargar el CubesViewer.
```bash
git clone https://github.com/jjmontesl/cubesviewer.git
```
- Si tiene el server del slice.ini encendido desactivelo con `CTRL + C`

- Crear un archivo nuevo dentro de data/`server.py`.
  - De acuerdo a sus datos, dentro hay una seccion donde ingresamos el .ini como string (ahi puede cambiar de acuerdo a su conveniencia).
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_14.png)
- Ingresar el siguiente comando:
```bash
python .\data\server.py
```
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_16.png)
Ya anda, perfectamente.

- En otra terminal aparte, no cerrar donde corre el servidor.


```bash
start .\cubesviewer\html\studio.html
```
Se abrira, en nuestro navegador la siguiente pagina (incluire todas las imagenes).

**Ingresar la url, que recibimos por el servidor**
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_17.png)

**En este paso, al inicio suele tardar en ver la tabla del hecho tener paciencia tarda poco  (1 min aprox), si sale el nombre del hecho dan click y listo.**
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_18.png)

**Esto veremos inicialmente, pero podemos hacer varias cosas.**
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_19.png)

Esto que vimos es el punto de partida.
Se inició en la vista "Aggregated data" (Datos Agregados), que mostraba una única fila con los totales generales del cubo (ej. Suma de Cantidad: 48.00, Suma de Monto: 12 095.00, etc.)

1.Vamos a utilizar una consulta.

http://localhost:5000/cube/ventas/aggregate?drilldown=producto.subcategoria&aggregates=cantidad_sum
Que es un drill down,  que agrupoa los resultados por la dimension Producto/subcategorias y ademas para cada grupo quiero que calcules la medida llamada `Suma de Cantidad` (cuyo nombre interno es cantidad_sum). Que devuleve esto, si lo probamos en el navegador.

![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_25.png)

Es la aplicación CubesViewer la que lee este JSON y decide si lo dibuja como una tabla o como un gráfico de barras.

- Abres CubesViewer y seleccionas el cubo "ventas".
- Haces clic en el botón `[▼ Drilldown]` en la barra de herramientas.
- Seleccionas la dimensión que quieres analizar, en este caso, "Producto / Subcategoría".


![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_21.png)
*La vista "Aggregated data" se actualiza. Ahora, en lugar de una fila, ves múltiples filas: una por cada subcategoría, cada una con su propia "Suma de Cantidad".*
    - De la siguiente manera, vamos a CHARTS
        - View->Measure->cantidad->Suma de cantidad
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_26.png)
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_24.png)

## Ejes del Gráfico

- **Eje Y (Vertical):** Representa el valor de la *Suma de Cantidad*.  
  - Cuanto más alta es la barra, mayor es la cantidad vendida.

- **Eje X (Horizontal) y Leyenda:**  
  - Cada barra individual (y su color correspondiente en la leyenda) representa un miembro de la dimensión **"Producto / Subcategoría"**.

## Lectura del Gráfico

- **Electrónica / Accesorios** (Barra Azul)  
  - Es la categoría con la *Suma de Cantidad* más alta, alcanzando **32** unidades.

- **Electrónica / Computadoras** (Barra Celeste)  
  - Segunda categoría con más cantidad: **6** unidades.

- **Electrónica / Monitores** (Naranja) y **Muebles / Oficina** (Naranja Claro)  
  - Son las categorías con las menores cantidades vendidas.

## ¿Para qué nos sirve esto?

Nos permite **tomar decisiones de negocio rápidas y basadas en datos reales**.  
Por ejemplo, al analizar las categorías de productos que más se venden:

- **"Electrónica / Accesorios"** es la categoría estrella.  
  - Se vende **mucho más** que todas las demás categorías juntas.

## Acciones y Beneficios

### 1. Gestión de Inventario
- Asegurar suficiente stock de **Accesorios**, ya que es lo que más se mueve.  
- Reducir stock de **Muebles / Oficina** para no tener capital parado.

### 2. Marketing y Ventas
- Preguntarse:  
  - ¿Por qué **Muebles / Oficina** y **Monitores** se venden tan poco?  
  - ¿Necesitan promoción?  
  - ¿O deberíamos enfocar la publicidad en **Accesorios**, que ya son un éxito?

### 3. Estrategia
- Detectar riesgos:  
  - Las ventas dependen principalmente de **una sola categoría**.  
  - Preguntarse:  
    - ¿Qué pasaría si el proveedor de accesorios falla?  
    - ¿Deberíamos impulsar las otras categorías para diversificar?