# Guía de Configuración y Mantenimiento – Cubes + SQLite

## Nombre de la tabla de hechos

El cube por defecto busca una tabla con el mismo nombre que el cube.
Si tu tabla se llama `fact_mantenimiento`, en el `modelo.json` debes declarar:

```json
"fact": "fact_mantenimiento"
```

dentro del objeto del cube. Alternativamente, puedes renombrar la tabla en la base de datos a `mantenimiento`.

---

## Rutas y permisos

* El archivo `slicer.ini` (o el fichero de configuración equivalente) debe apuntar al `.db` correcto y al `modelo.json` correcto.
* Usa rutas absolutas o ejecuta `slicer serve` desde la carpeta donde estén los archivos para evitar errores de “archivo no encontrado”.
* El proceso que ejecuta `slicer` debe tener permiso de lectura sobre ambos archivos (`.db` y `modelo.json`).

---

## Tablas y columnas deben existir y coincidir

1. Verifica que las tablas existen en la base (por ejemplo con `.tables` en SQLite).
2. Verifica que todas las columnas mencionadas en el modelo existen (claves primarias, medidas y atributos de dimensiones).

---

## Claves primarias y relaciones

* Cada dimensión debe tener su columna clave única (`pk_avion`, `pk_tiempo`, etc.).
* Las relaciones (`joins`) en el modelo deben apuntar a columnas que existan realmente.
* Si enlazas la misma dimensión dos veces (por ejemplo `pk_tiempo_inicio` y `pk_tiempo_fin`), usa alias adecuados en el modelo para distinguirlas.

---

## Mappings y joins

* Los nombres usados en `mappings` y `joins` deben coincidir exactamente con los nombres de columnas en la base de datos.
* Respeta mayúsculas/minúsculas si tu base de datos las distingue.
* Verifica que los alias no entren en conflicto con otras dimensiones o joins.

---

## Medidas y tipos de datos

* Las columnas usadas como medidas (`monto_precio_base`, `cant_horas_practica_base`, etc.) deben ser numéricas (`REAL`, `INTEGER`).
* Si hay valores `NULL` o texto en columnas que se usan como medidas, pueden causar errores o resultados inesperados en las agregaciones.

---

## Reiniciar después de cambios

Cada vez que modifiques el `.db` o el `modelo.json`, reinicia el servidor `slicer` para que recargue la configuración y el modelo:

```bash
slicer serve slicer.ini
```

o si arrancas con un script Flask:

```bash
python data/server.py
```

---

## Logs y diagnóstico

* Si falla algo, revisa el log que imprime `slicer` o Flask en la consola.
* Errores comunes:

  * `NoSuchTableError`: la tabla no existe.
  * `NoSuchColumnError`: la columna no existe o está mal escrita.
  * `ModelError`: problema en joins, mappings o medidas (por ejemplo expression vs measure).
* Para obtener más detalle habilita debug o redirige la salida de error a un archivo:

```powershell
$env:FLASK_ENV = "development"
python data/server.py 2> data/server_error.log
type data\server_error.log
```

---

## Precauciones al agregar nuevos dominios

Al extender el modelo (nuevas dimensiones, medidas, joins):

1. Agrega primero la tabla y sus claves en la base de datos.
2. Actualiza el `modelo.json` con sus mappings y joins.
3. Valida el JSON y reinicia el servidor.
4. Prueba con una URL simple (por ejemplo `aggregate?nro_mantenimientos`) antes de consultas complejas.

---

## Ejemplos de comandos y comprobaciones útiles

### Comprobar tablas y esquema (SQLite)

```powershell
# listar tablas (si tienes sqlite3 en PATH)
sqlite3 mantenimiento.db ".tables"

# ver columnas de una tabla
sqlite3 mantenimiento.db "PRAGMA table_info('fact_mantenimiento');"

# mostrar primeras filas
sqlite3 mantenimiento.db "SELECT * FROM fact_mantenimiento LIMIT 5;"
```

Si no tienes `sqlite3` en PATH, puedes usar Python:

```python
import sqlite3
con = sqlite3.connect("data/mantenimiento.db")
cur = con.cursor()
cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
print(cur.fetchall())
con.close()
```

---

## Endpoints de Slicer/Cubes útiles para pruebas

(suponer `http://localhost:5000` y cube `mantenimiento`)

* Modelo del cube:

```
GET /cube/mantenimiento/model
```

* Agregación simple (sum, count, avg según agregados definidos en el modelo):

```
GET /cube/mantenimiento/aggregate?aggregate=total_ingresos
GET /cube/mantenimiento/aggregate?aggregate=nro_mantenimientos
```

* Drilldown por dimensión:

```
GET /cube/mantenimiento/aggregate?aggregate=total_ingresos&drilldown=tiempo.anio
```

* Filtrar (cut) por dimensión:

```
GET /cube/mantenimiento/aggregate?aggregate=total_ingresos&cut=mecanico.pk_mecanico:1
```

* Ver hechos (facts) — filas:

```
GET /cube/mantenimiento/facts?limit=10
```

Ejemplo con curl:

```bash
curl "http://localhost:5000/cube/mantenimiento/aggregate?aggregate=total_ingresos"
```

---

## Resumen de buenas prácticas

* Mantener sincronía entre el modelo JSON y la base de datos.
* Usar nombres consistentes para tablas, columnas y atributos del modelo.
* Validar `modelo.json` y los cambios en la base antes de reiniciar el servidor.
* Revisar logs cuando algo falla y habilitar debug para obtener trazas completas.

---

## Tip para automatizar verificaciones

Si vas a añadir dominios frecuentemente, crea un script pequeño que, antes de levantar el servidor, ejecute `PRAGMA table_info(tabla)` para validar que las columnas necesarias existen y devuelva un informe de discrepancias. Esto reduce errores humanos al desplegar cambios en el modelo.
