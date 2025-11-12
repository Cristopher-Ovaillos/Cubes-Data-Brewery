-- ============================================
-- CREAR TABLAS DIMENSIONALES
-- ============================================

-- Dimension: Avion
CREATE TABLE dim_avion (
    pk_avion INTEGER PRIMARY KEY,
    matricula TEXT NOT NULL,
    modelo TEXT,
    cant_pasajeros INTEGER
);

-- Dimension: Mecanico
CREATE TABLE dim_mecanico (
    pk_mecanico INTEGER PRIMARY KEY,
    dni_mecanico TEXT NOT NULL,
    nombre_apellido TEXT,
    especialidad TEXT
);

-- Dimension: Aprendiz
CREATE TABLE dim_aprendiz (
    pk_aprendiz INTEGER PRIMARY KEY,
    dni_aprendiz TEXT NOT NULL,
    nombre_apellido TEXT,
    nivel_formacion TEXT,
    sexo TEXT
);

-- Dimension: Tiempo
CREATE TABLE dim_tiempo (
    pk_tiempo INTEGER PRIMARY KEY,
    fecha_completa TEXT NOT NULL,
    anio INTEGER,
    mes_numero INTEGER,
    mes_nombre TEXT,
    trimestre INTEGER,
    dia INTEGER
);

-- Dimension: Tipo de Trabajo
CREATE TABLE dim_tipo_trabajo (
    pk_tipo_trabajo INTEGER PRIMARY KEY,
    desc_tipo_trabajo TEXT NOT NULL
);

-- Dimension: Tipo de Tarea
CREATE TABLE dim_tipo_tarea (
    pk_tipo_tarea INTEGER PRIMARY KEY,
    desc_tipo_tarea TEXT NOT NULL
);

-- ============================================
-- TABLA DE HECHOS
-- ============================================

CREATE TABLE fact_mantenimiento (
    pk_fact INTEGER PRIMARY KEY,
    pk_avion INTEGER NOT NULL,
    pk_mecanico INTEGER NOT NULL,
    pk_aprendiz INTEGER,
    pk_tiempo_inicio INTEGER NOT NULL,
    pk_tiempo_fin INTEGER,
    pk_tipo_trabajo INTEGER NOT NULL,
    pk_tipo_tarea INTEGER NOT NULL,
    
    -- Atributos base para medidas
    monto_precio_base REAL,
    cant_horas_practica_base INTEGER,
    horas_vuelo_base INTEGER,
    ciclos_vuelo_base INTEGER,
    
    FOREIGN KEY (pk_avion) REFERENCES dim_avion(pk_avion),
    FOREIGN KEY (pk_mecanico) REFERENCES dim_mecanico(pk_mecanico),
    FOREIGN KEY (pk_aprendiz) REFERENCES dim_aprendiz(pk_aprendiz),
    FOREIGN KEY (pk_tiempo_inicio) REFERENCES dim_tiempo(pk_tiempo),
    FOREIGN KEY (pk_tiempo_fin) REFERENCES dim_tiempo(pk_tiempo),
    FOREIGN KEY (pk_tipo_trabajo) REFERENCES dim_tipo_trabajo(pk_tipo_trabajo),
    FOREIGN KEY (pk_tipo_tarea) REFERENCES dim_tipo_tarea(pk_tipo_tarea)
);

  -- POBLAR 

-- DIMENSION: AVION
INSERT INTO dim_avion(pk_avion, matricula, modelo, cant_pasajeros) VALUES (1, 'LV-AAA', 'Boeing 737-800', 160);
INSERT INTO dim_avion(pk_avion, matricula, modelo, cant_pasajeros) VALUES (2, 'LV-BBB', 'Airbus A320', 150);
INSERT INTO dim_avion(pk_avion, matricula, modelo, cant_pasajeros) VALUES (3, 'LV-CCC', 'Embraer 190', 100);

-- DIMENSION: MECANICO
INSERT INTO dim_mecanico(pk_mecanico, dni_mecanico, nombre_apellido, especialidad) VALUES (1, '12345678', 'Juan Pérez', 'Motores');
INSERT INTO dim_mecanico(pk_mecanico, dni_mecanico, nombre_apellido, especialidad) VALUES (2, '87654321', 'María Gómez', 'Avionica');
INSERT INTO dim_mecanico(pk_mecanico, dni_mecanico, nombre_apellido, especialidad) VALUES (3, '11223344', 'Carlos Ruiz', 'Estructuras');

-- DIMENSION: APRENDIZ
INSERT INTO dim_aprendiz(pk_aprendiz, dni_aprendiz, nombre_apellido, nivel_formacion, sexo) VALUES (1, '22334455', 'Ana López', 'Inicial', 'F');
INSERT INTO dim_aprendiz(pk_aprendiz, dni_aprendiz, nombre_apellido, nivel_formacion, sexo) VALUES (2, '33445566', 'Diego Martín', 'Intermedio', 'M');

-- DIMENSION: TIPO TRABAJO
INSERT INTO dim_tipo_trabajo(pk_tipo_trabajo, desc_tipo_trabajo) VALUES (1, 'Mantenimiento Preventivo');
INSERT INTO dim_tipo_trabajo(pk_tipo_trabajo, desc_tipo_trabajo) VALUES (2, 'Mantenimiento Correctivo');

-- DIMENSION: TIPO TAREA
INSERT INTO dim_tipo_tarea(pk_tipo_tarea, desc_tipo_tarea) VALUES (1, 'Inspección General');
INSERT INTO dim_tipo_tarea(pk_tipo_tarea, desc_tipo_tarea) VALUES (2, 'Cambio de Motor');
INSERT INTO dim_tipo_tarea(pk_tipo_tarea, desc_tipo_tarea) VALUES (3, 'Revisión Avionica');

-- DIMENSION: TIEMPO (ejemplo: pk_tiempo entero, fecha ISO YYYY-MM-DD)
-- Añadimos varios días de 2024 y 2025
INSERT INTO dim_tiempo(pk_tiempo, fecha_completa, anio, mes_numero, mes_nombre, trimestre, dia) VALUES (1, '2024-11-01', 2024, 11, 'Noviembre', 4, 1);
INSERT INTO dim_tiempo(pk_tiempo, fecha_completa, anio, mes_numero, mes_nombre, trimestre, dia) VALUES (2, '2024-11-15', 2024, 11, 'Noviembre', 4, 15);
INSERT INTO dim_tiempo(pk_tiempo, fecha_completa, anio, mes_numero, mes_nombre, trimestre, dia) VALUES (3, '2024-12-05', 2024, 12, 'Diciembre', 4, 5);
INSERT INTO dim_tiempo(pk_tiempo, fecha_completa, anio, mes_numero, mes_nombre, trimestre, dia) VALUES (4, '2025-01-10', 2025, 1, 'Enero', 1, 10);
INSERT INTO dim_tiempo(pk_tiempo, fecha_completa, anio, mes_numero, mes_nombre, trimestre, dia) VALUES (5, '2025-02-20', 2025, 2, 'Febrero', 1, 20);
INSERT INTO dim_tiempo(pk_tiempo, fecha_completa, anio, mes_numero, mes_nombre, trimestre, dia) VALUES (6, '2025-03-03', 2025, 3, 'Marzo', 1, 3);

-- HECHOS: fact_mantenimiento
-- pk_fact autoincrement? Si no está autoincrement, usar valores explícitos
INSERT INTO fact_mantenimiento(pk_fact, pk_avion, pk_mecanico, pk_aprendiz, pk_tiempo_inicio, pk_tiempo_fin, pk_tipo_trabajo, pk_tipo_tarea, monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base)
VALUES (1, 1, 1, 1, 1, 2, 1, 1, 1500.00, 8, 120, 400);

INSERT INTO fact_mantenimiento(pk_fact, pk_avion, pk_mecanico, pk_aprendiz, pk_tiempo_inicio, pk_tiempo_fin, pk_tipo_trabajo, pk_tipo_tarea, monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base)
VALUES (2, 1, 2, NULL, 2, 3, 2, 2, 12000.00, 0, 200, 800);

INSERT INTO fact_mantenimiento(pk_fact, pk_avion, pk_mecanico, pk_aprendiz, pk_tiempo_inicio, pk_tiempo_fin, pk_tipo_trabajo, pk_tipo_tarea, monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base)
VALUES (3, 2, 3, 2, 3, 4, 1, 3, 3000.00, 12, 90, 300);

INSERT INTO fact_mantenimiento(pk_fact, pk_avion, pk_mecanico, pk_aprendiz, pk_tiempo_inicio, pk_tiempo_fin, pk_tipo_trabajo, pk_tipo_tarea, monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base)
VALUES (4, 3, 1, NULL, 4, 5, 1, 1, 800.00, 4, 50, 120);

INSERT INTO fact_mantenimiento(pk_fact, pk_avion, pk_mecanico, pk_aprendiz, pk_tiempo_inicio, pk_tiempo_fin, pk_tipo_trabajo, pk_tipo_tarea, monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base)
VALUES (5, 2, 2, 1, 5, 6, 2, 2, 5000.00, 6, 160, 600);

INSERT INTO fact_mantenimiento(pk_fact, pk_avion, pk_mecanico, pk_aprendiz, pk_tiempo_inicio, pk_tiempo_fin, pk_tipo_trabajo, pk_tipo_tarea, monto_precio_base, cant_horas_practica_base, horas_vuelo_base, ciclos_vuelo_base)
VALUES (6, 1, 3, 2, 6, 6, 1, 3, 2200.00, 10, 110, 350);