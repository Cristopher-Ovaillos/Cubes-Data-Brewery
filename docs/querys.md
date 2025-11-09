# Consultas OLAP con Cubes / Slicer (GUIA HECHO POR IA para aclarar)

Este README explica cómo hacer consultas OLAP con **Cubes / Slicer**, incluyendo conceptos como drill-down, roll-up, slice, dice, split, y cómo emular ROLLUP/GROUPING SETS. Se dan ejemplos concretos aplicables a cualquier cubo.

> **Nota:** en la documentación técnica aparecen placeholders entre `< >`. Estos **no** se envían tal cual: se reemplazan por el valor real sin los símbolos `<` o `>`.

> La mayoria de comandos a copiar pone GET, pero en el navegador ponen URL/cube/ventas/aggregate?cut=cliente.pais:Argentina|tiempo.anio:2024&aggregates=cantidad_sum,monto_sum (GET /  sacan el GET)

---

## 1. Conceptos clave

* **Cubo:** estructura multidimensional con medidas y dimensiones.
* **Cell (singular):** la intersección de filtros (cuts) aplicada en la consulta.
* **Cells (plural):** detalle desglosado cuando pedís split o drill-down.
* **Summary:** agregados (SUM, AVG, COUNT) para la cell.
* **Drill‑down:** bajar a un nivel más detallado. Ej.: `tiempo:mes` baja de año a mes.
* **Roll‑up:** subir al nivel de agregación superior. Ej.: agregar por año en lugar de mes.
* **Slice:** fijar un valor de una dimensión. Ej.: `cliente.pais:Argentina`.
* **Dice:** aplicar varios filtros simultáneos. Ej.: `cliente.pais:Argentina|tiempo.anio:2024`.
* **Split:** pedir que la agregación se desglosé por una dimensión, llenando `cells`.

**Ejemplo práctico:**

* `Drill-down`: ventas por año → ventas por mes.
* `Roll-up`: ventas por mes → ventas por año (subtotales).
* `Slice`: ventas de un país específico.
* `Dice`: ventas de un país y un año específico.
* `Split`: desglose de ventas por cliente.

---

## 2. Endpoints principales

* `GET /cube/<cube>/aggregate` — pedir agregados y drilldowns.
* `GET /cube/<cube>/members/<dimension>` — listar miembros de una dimensión.
* `GET /cube/<cube>/facts` — obtener filas detalle (facts) dentro de una cell.
* `GET /cube/<cube>/cell` — ver la descripción de una cell (debug).

> Reemplaza `<cube>` y `<dimension>` con los nombres reales del cubo y la dimensión.

---

## 3. Sintaxis general de consulta

```
GET /cube/<cube>/aggregate?cut=<cuts>&drilldown=<drilldowns>&aggregates=<agg_list>&split=<split_dim>&order=<expr>&page=<n>&page_size=<n>&format=<csv|json>
```

* **cut**: filtros que definen la cell. Ejemplos:

  * `cut=cliente.pais:Argentina`
  * `cut=cliente.pais:Argentina|tiempo.anio:2024`
  * `cut=tiempo.fecha:2024-01-01..2024-12-31`
* **drilldown**: nivel(es) de detalle. Ej.: `drilldown=tiempo:mes|producto.categoria`
* **aggregates**: medidas a agregar. Ej.: `monto_sum,cantidad_sum`
* **split**: dimensión para desglosar (rellena `cells`). Ej.: `split=cliente`
* **order, page, page_size, format**: control de orden, paginación y formato.

---

## 4. Campos de la respuesta

```json
{
  "summary": { ... },
  "cells": [ ... ],
  "aggregates": [ ... ],
  "cell": [ ... ],
  "attributes": [ ... ],
  "remainder": { ... },
  "has_split": false
}
```

* `summary`: agregados de la cell.
* `aggregates`: lista de agregados devueltos.
* `cell`: descripción de la cell (filtros aplicados).
* `cells`: filas detalladas si pediste `split` o `drilldown`.
* `remainder`: información adicional.
* `attributes`: atributos incluidos.
* `has_split`: true si hay `cells` con desagregación.

---

## 5. Ejemplos de consultas

### 5.1 Resumen total

```
GET /cube/ventas/aggregate?cut=cliente.pais:Argentina|tiempo.anio:2024&aggregates=cantidad_sum,monto_sum
```

Devuelve un `summary` con totales para Argentina en 2024; `cells` estará vacío.

### 5.2 Drill-down por mes

```
GET /cube/ventas/aggregate?cut=cliente.pais:Argentina&drilldown=tiempo:mes&aggregates=monto_sum
```

Desglose de ventas por mes; se llena `cells` con cada mes.

### 5.3 Split por cliente

```
GET /cube/ventas/aggregate?cut=tiempo.anio:2024&split=cliente&aggregates=monto_sum&page=1&page_size=50
```

Desglose por cliente (50 filas por página).

### 5.4 Drilldown múltiple (cliente × categoría)

```
GET /cube/ventas/aggregate?cut=tiempo.anio:2024&drilldown=cliente|producto.categoria&aggregates=monto_sum,cantidad_sum
```

Cada combinación de cliente y categoría con sus agregados.

---

## 6. Simulación de ROLLUP / GROUPING SETS / CUBE

### Roll-up

* SQL: `ROLLUP(a,b)` → subtotal por b y total general.
* Cubes: múltiples consultas con drilldowns menores y mayores:

```http
# Subtotal por subcategoría
GET /cube/ventas/aggregate?drilldown=producto:subcategoria&aggregates=monto_sum
# Subtotal por categoría
GET /cube/ventas/aggregate?drilldown=producto:categoria&aggregates=monto_sum
# Total general
GET /cube/ventas/aggregate?aggregates=monto_sum
```

### Grouping Sets

* SQL: `GROUPING SETS ((a,b),(a))`
* Cubes: ejecutar varias queries y combinar:

```http
# (a,b)
GET /cube/ventas/aggregate?drilldown=cliente|tiempo&aggregates=monto_sum,cantidad_sum
# (a)
GET /cube/ventas/aggregate?drilldown=cliente&aggregates=monto_sum,cantidad_sum
# total
GET /cube/ventas/aggregate?aggregates=monto_sum,cantidad_sum
```

### CUBE

* SQL: `CUBE(a,b)` genera todas las combinaciones. En Cubes:

  * Ejecutar todas las combinaciones de drilldowns y roll-ups.
  * Combinar resultados en cliente y usar `NULL` o `TOTAL` para marcar agregaciones parciales.

---

## 7. Cómo Cubes traduce la consulta a SQL

1. `cut` → WHERE
2. `drilldown`/`split` → GROUP BY
3. `aggregates` → funciones SUM/AVG/COUNT
4. `mappings` en `modelo.json` → columnas y joins físicos

Activar `log_level = debug` en `slicer.ini` para ver el SQL generado.

---

## 8. Buenas prácticas

* Definir jerarquías y `label_attribute` en `modelo.json`.
* Evitar drilldowns muy grandes sin paginación.
* Usar `page` y `page_size` para `cells` y `facts`.
* Para grandes combinaciones (ROLLUP/GROUPING SETS), considerar vistas SQL en la base.

---

## 9. Fuentes

* Cubes / Slicer: [https://cubes.readthedocs.io/](https://cubes.readthedocs.io/), [https://pythonhosted.org/cubes/server.html](https://pythonhosted.org/cubes/server.html)
* Apache Kylin — `GROUPING SETS`, `ROLLUP`, `CUBE`: [https://kylin.apache.org/docs/](https://kylin.apache.org/docs/)
* PostgreSQL — [ROLLUP / GROUPING SETS](https://www.postgresql.org/docs/current/queries-table-expressions.html)

