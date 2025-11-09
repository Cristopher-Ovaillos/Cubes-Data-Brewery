### Slicer.ini (GUIA HECHO POR IA para aclarar)

Ese `slicer.ini` (o archivo `.ini`) le dice al servidor de **Cubes / Slicer** cómo arrancar: qué modelo usar, cómo conectarse a la base de datos y en qué host/puerto escuchar. Cada sección controla una parte:

* ` [workspace]`

  * `model = modelo.json` → indica **el archivo JSON** que contiene la definición del modelo (cubos, dimensiones, mappings). Es el “modelo lógico” que Cubes cargará al iniciar.

* `[store]`

  * `type = sql` → indica que el backend de datos es SQL.
  * `url = sqlite:///ventas.db` → **cadena de conexión** a la base de datos. En este caso, una base SQLite local llamada `ventas.db`.
  * `schema = main` → (opcional) esquema a usar en bases que soportan esquemas (en SQLite suele ser `main`).

* `[server]`

  * `host = localhost` → host donde escucha el servidor (solo accesible desde la misma máquina).
  * `port = 5000` → puerto HTTP.
  * `reload = yes` → modo desarrollo: hace que el servidor **recargue** cambios sin reiniciarlo manualmente (útil cuando editás el `modelo.json` u otros archivos).
  * `log_level = info` → cuánto detalle registra en los logs (puede ser `debug`, `info`, `warning`, `error`).

* `[models]`

  * `main = modelo.json` → lista de modelos nombrados disponibles para el servidor. Permite tener varios modelos y referenciarlos por nombre. En este ejemplo `main` es el alias que apunta a `modelo.json`.

En conjunto: al ejecutar el servidor con este `.ini`, Slicer/Cubes carga `modelo.json`, conecta con `ventas.db` y expone un API HTTP en `http://localhost:5000` para hacer consultas OLAP sobre los cubos definidos.

---

### Si cambiamos de base de datos:

1. **Editar la URL del store**

   * Cambiar `url = sqlite:///ventas.db` por la cadena de conexión del nuevo motor. Ejemplos:

     ```ini
     # SQLite (archivo local)
     url = sqlite:///ruta/absoluta/ventas.db

     # PostgreSQL
     url = postgresql://usuario:password@host:5432/nombre_db

     # MySQL
     url = mysql+pymysql://usuario:password@host:3306/nombre_db
     ```
2. **Instalar el driver**

   * Para PostgreSQL/MySQL tenés que tener instaladas las librerías Python adecuadas (`psycopg2`, `pymysql`, `sqlalchemy` ya instalado, etc.).
3. **Revisar `schema`**

   * Si usás Postgres y tus tablas están en un esquema distinto, ajustá `schema = public` o el apropiado.
4. **Verificar nombres físicos y mappings**

   * Si la estructura de la nueva base (nombres de tablas/columnas) difiere, **actualizá los mappings** en `modelo.json` para que apunten a las columnas correctas.
5. **Datos / migraciones**

   * Asegurate de que la nueva BD contiene los datos o que cargás/exportás lo necesario.
6. **Reiniciar o confiar en `reload`**

   * Con `reload = yes`, el servidor puede recargar la conexión y el modelo automáticamente en desarrollo; en producción es mejor reiniciar manualmente para evitar inconsistencias.
7. **Probar**

   * Hacer requests simples: `GET http://localhost:5000/info` y `GET http://localhost:5000/cubes` para confirmar que el servidor ve la DB y carga los cubos.

---

### Qué pasa si cambiás el modelo (`modelo.json`) y cómo hacerlo bien

1. **Editar `modelo.json`**

   * Ahí definís cubos, dimensiones, medidas, mappings y joins. Cambios típicos: nuevos atributos, renombrar medidas o corregir mappings.
2. **Si `reload = yes`**

   * En desarrollo, el servidor suele detectar cambios y recargar el modelo automáticamente. Útil para iterar rápido.
3. **Si `reload = no` o producción**

   * Tenés que **reiniciar el servidor** para que cargue el nuevo modelo.
   * Reiniciar garantiza que no queden estados inconsistentes en memoria.
4. **Consistencia entre modelo y BD**

   * Si agregás atributos lógicos nuevos, asegurate de que existan las columnas físicas mapeadas en la BD (o crear vistas/consultas que las expongan).
5. **Versionar el modelo**

   * Mantener `modelo.json` en control de versiones (git) es buena práctica para poder revertir cambios o auditar la evolución del modelo.
6. **Probar endpoints**

   * Después de cambiar el modelo, llamar `GET /cube/<tu_cubo>/model` para verificar que la definición se cargó correctamente.

---

### Recomendaciones y comentarios prácticos

* **Desarrollo vs producción**

  * `reload = yes` es cómodo para desarrollo. En producción poner `reload = no`, `host = 0.0.0.0` si querés exponer el servicio a la red, y proteger con proxy (Nginx) y TLS.
* **Seguridad**

  * Evitar exponer `host = localhost` si necesitás acceso externo; mejor configurarlo cuidadosamente y usar firewall/proxy.
* **Backups**

  * Antes de cambiar la base o estructura, hacé backups de la base de datos y del `modelo.json`.
* **Múltiples modelos**

  * Podés definir varios alias en `[models]` (`main = modelo.json`, `otro = otro_modelo.json`) para servir distintos modelos desde la misma instancia.
* **Logs**

  * `log_level = debug` ayuda cuando algo falla (permitirá ver cómo Cubes genera SQL y por qué falla un mapping).
* **Comando para arrancar el servidor**

  * Normalmente se arranca con algo equivalente a (ejemplo usado en tus pruebas):

    ```bash
    slicer serve path/al/tu/slicer.ini
    ```
  * Si hay problemas, revisar consola y logs para ver errores de conexión o de carga del modelo.

---

### Cheatsheet rápido

* Cambiar BD: editar `[store] url`, instalar driver, verificar mappings, reiniciar (o confiar en `reload`).
* Cambiar modelo: editar `modelo.json`, comprobar mappings y jerarquías, reiniciar si no hay `reload`.
* Probar: `GET /info` y `GET /cubes` / `GET /cube/<cubo>/model`.
* En producción: `reload = no`, `host = 0.0.0.0` + proxy reverso y TLS.


