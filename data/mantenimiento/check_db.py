#!/usr/bin/env python3
import sqlite3, sys

DB = "data/mantenimiento.db"  # si ejecutás desde la raíz del proyecto usa data/..., si estás en data/ poner "mantenimiento.db"

def q(con, sql, params=()):
    cur = con.cursor()
    try:
        cur.execute(sql, params)
        return cur
    except Exception as e:
        print("ERROR SQL:", sql)
        print(e)
        return None

def show_rows(cur, maxrows=20):
    if cur is None: 
        return
    cols = [d[0] for d in cur.description] if cur.description else []
    rows = cur.fetchmany(maxrows)
    for r in rows:
        print({c: r[i] for i,c in enumerate(cols)})

def main():
    try:
        con = sqlite3.connect(DB)
    except Exception as e:
        print("No se pudo abrir DB:", e)
        sys.exit(1)

    print("\n== Tablas ==")
    cur = q(con, "SELECT name, type FROM sqlite_master WHERE type IN ('table','view') ORDER BY name;")
    show_rows(cur)

    print("\n== PRAGMA table_info('fact_mantenimiento') ==")
    cur = q(con, "PRAGMA table_info('fact_mantenimiento');")
    show_rows(cur)

    print("\n== Primeras 8 filas de fact_mantenimiento ==")
    cur = q(con, "SELECT * FROM fact_mantenimiento LIMIT 8;")
    show_rows(cur)

    print("\n== Conteo total ==")
    cur = q(con, "SELECT COUNT(*) AS total FROM fact_mantenimiento;")
    show_rows(cur)

    print("\n== SUM monto_precio_base, SUM cant_horas_practica_base ==")
    cur = q(con, "SELECT SUM(monto_precio_base) as sum_monto, SUM(cant_horas_practica_base) as sum_horas FROM fact_mantenimiento;")
    show_rows(cur)

    print("\n== typeof por columnas clave (monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base) ==")
    for col in ("monto_precio_base","cant_horas_practica_base","horas_vuelo_base","ciclos_vuelo_base"):
        cur = q(con, "SELECT typeof(%s) as tipo, COUNT(*) as cnt FROM fact_mantenimiento GROUP BY typeof(%s);" % (col, col))
        print("--", col)
        show_rows(cur)

    print("\n== NULLs en columnas medidas ==")
    cur = q(con, "SELECT COUNT(*) as null_count FROM fact_mantenimiento WHERE monto_precio_base IS NULL OR cant_horas_practica_base IS NULL OR horas_vuelo_base IS NULL OR ciclos_vuelo_base IS NULL;")
    show_rows(cur)

    print("\n== PKs de fact sin match en dimensiones (avion, mecanico) ==")
    cur = q(con, "SELECT DISTINCT f.pk_avion FROM fact_mantenimiento f LEFT JOIN dim_avion d ON f.pk_avion = d.pk_avion WHERE d.pk_avion IS NULL;")
    show_rows(cur)
    cur = q(con, "SELECT DISTINCT f.pk_mecanico FROM fact_mantenimiento f LEFT JOIN dim_mecanico d ON f.pk_mecanico = d.pk_mecanico WHERE d.pk_mecanico IS NULL;")
    show_rows(cur)

    con.close()
    print("\n== FIN ==")

if __name__ == '__main__':
    main()
