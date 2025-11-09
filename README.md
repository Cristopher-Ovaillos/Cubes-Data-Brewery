# GUIA instalacion de Cubes

```bash
git clone https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery.git

cd Cubes-Data-Brewery
```
---
## Que es CUBES


---
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




### Carpeta de Trabajo
./Cubes-Data-Brewery


*En nuestro projecto mismo, ingresar los siguientes comandos en orden.*
```bash
# Crear un entorno virtual 
python -m venv cubes_env

# Activar el entorno virtual
.\cubes_env\Scripts\activate 
#puedo desactivarlo ingresando en la terminal "deactivate"
```
![img-carpeta-projecto](https://github.com/Cristopher-Ovaillos/Cubes-Data-Brewery/blob/main/img/image_1.png)


**Dentro del entorno Virtual creado anteriormente**
```bash
# Instalar versiones específicas que funcionan juntas 
pip install cubes==1.1  
pip install sqlalchemy==1.3.24
pip install flask==1.1.4
pip install werkzeug==1.0.1
pip install jsonschema==3.2.0
pip install flask-cors
```

**IMPORTANTE**: Estas versiones son compatibles entre sí. NO instales otras versiones.

>**python -m venv cubes_env**   Es utilizado para crear un entorno virtual. Es un Python aislado, que permite instalar paquetes especificos sin afectar Python global. Entonces, cada projecto puede tener sus propias versiones de librerias. Si queremos tener otros projectos, esto nos evitara conflictos entre ellos (ej. si otro projecto necesita tal version de SQLACHEMY no habra problemas), MENTENEMOS EL SISTEMA LIMPIO.

>**cubes==1.1** Es el Framework OLAP que vamos a usar. Este lo que hace es traducir consultas dimensiones que serian los famosos cubes a SQL.

>**sqlalchemy==1.3.24** Cubes fue desarrollado alrededor de la API de SQLEALCHEMY. 

>**flask==1.1.4** Microframework web en Python. Cubes lo usa para servir el servidor OLAP vía HTTP.

>**werkzeug==1.0.1** Librería que Flask necesita internamente para manejar rutas, requests y responses.

>**jsonschema==3.2.0** Valida archivos JSON según un esquema definido. Cubes lo usa para validar modelos, dimensiones y cubos definidos en JSON.

>**flask-cors** Es una extensión para Flask que maneja CORS (Cross-Origin Resource Sharing). CORS es un mecanismo de seguridad en los navegadores que bloquea solicitudes entre dominios diferentes por defecto. Plantemos lo siguiente, Si nuestro servidor Flask (por ejemplo, Cubes OLAP) corre en localhost:5000 y querés acceder a él desde otra web o desde una aplicación JavaScript en localhost:5500, el navegador bloqueará la petición sin CORS. Entoces con esto permitimos configurar quien puede acceder al servidor y evitar errores de cross-origin Request Blocked que sucedia sin esto.




