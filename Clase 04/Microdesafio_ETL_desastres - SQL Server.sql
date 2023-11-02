/*PASO 1: CREAR BASE DE DATOS DE ORIGEN*/
-- Creo base de datos
CREATE DATABASE desastres;
USE desastres;

-- Creo tabla clima
create table desastres.clima(
año INT NOT NULL PRIMARY KEY,
Temperatura FLOAT NOT NULL,
Oxigeno FLOAT NOT NULL
);

-- Insertor valores manualmente
INSERT INTO desastres.clima VALUES (2023, 22.5,230);
INSERT INTO desastres.clima VALUES (2024, 22.7,228.6);
INSERT INTO desastres.clima VALUES (2025, 22.9,227.5);
INSERT INTO desastres.clima VALUES (2026, 23.1,226.7);
INSERT INTO desastres.clima VALUES (2027, 23.2,226.4);
INSERT INTO desastres.clima VALUES (2028, 23.4,226.2);
INSERT INTO desastres.clima VALUES (2029, 23.6,226.1);
INSERT INTO desastres.clima VALUES (2030, 23.8,225.1);

select * from desastres.clima;

-- Creo tabla desastres
create table desastres.desastres(
año INT NOT NULL PRIMARY KEY,
Tsunamis INT NOT NULL,
Olas_Calor INT NOT NULL,
Terremotos INT NOT NULL,
Erupciones INT NOT NULL,
Incendios INT NOT NULL
);

-- Insertor valores manualmente
INSERT INTO desastres.desastres VALUES (2023, 2,15, 6,7,50);
INSERT INTO desastres.desastres VALUES (2024, 1,12, 8,9,46);
INSERT INTO desastres.desastres VALUES (2025, 3,16, 5,6,47);
INSERT INTO desastres.desastres VALUES (2026, 4,12, 10,13,52);
INSERT INTO desastres.desastres VALUES (2027, 5,12, 6,5,41);
INSERT INTO desastres.desastres VALUES (2028, 4,18, 3,2,39);
INSERT INTO desastres.desastres VALUES (2029, 2,19, 5,6,49);
INSERT INTO desastres.desastres VALUES (2030, 4,20, 6,7,50);

-- Creo tabla muertes por rango de edad
create table desastres.muertes(
año INT NOT NULL PRIMARY KEY,
R_Menor15 INT NOT NULL,
R_15_a_30 INT NOT NULL,
R_30_a_45 INT NOT NULL,
R_45_a_60 INT NOT NULL,
R_M_a_60 INT NOT NULL
);

-- Insertor valores manualmente
INSERT INTO desastres.muertes VALUES (2023, 1000,1300, 1200,1150,1500);
INSERT INTO desastres.muertes VALUES (2024, 1200,1250, 1260,1678,1940);
INSERT INTO desastres.muertes VALUES (2025, 987,1130, 1160,1245,1200);
INSERT INTO desastres.muertes VALUES (2026, 1560,1578, 1856,1988,1245);
INSERT INTO desastres.muertes VALUES (2027, 1002,943, 1345,1232,986);
INSERT INTO desastres.muertes VALUES (2028, 957,987, 1856,1567,1756);
INSERT INTO desastres.muertes VALUES (2029, 1285,1376, 1465,1432,1236);
INSERT INTO desastres.muertes VALUES (2030, 1145,1456, 1345,1654,1877);


/*PASO 2: CREAR BASE DE DATOS DATA WAREHOUSE QUE ALMACENE ESTADÍSTICAS*/
CREATE DATABASE desastres_bde;
USE desastres_bde;


CREATE TABLE dbo.desastres_final (
Cuatrenio varchar(20) NOT NULL PRIMARY KEY,
Temp_AVG FLOAT NOT NULL,
Oxi_AVG FLOAT NOT NULL,
T_Tsunamis INT NOT NULL,
T_OlasCalor INT NOT NULL,
T_Terremotos INT NOT NULL,
T_Erupciones INT NOT NULL, 
T_Incendios INT NOT NULL,
M_Jovenes_AVG FLOAT NOT NULL,
M_Adutos_AVG FLOAT NOT NULL,
M_Ancianos_AVG FLOAT NOT NULL
);

select * from DESASTRES_BDE.dbo.desastres_final;

--------------------------------

/*PASO 3: CREAR EL PROCEDIMIENTO EN LA BASE DE ORIGEN*/
USE desastres;


CREATE PROCEDURE pETL_Desastres
AS
BEGIN
  -- Vacía la tabla desastres_bde.desastres_final
  TRUNCATE TABLE desastres_bde.dbo.desastres_final;

  -- Inserta los nuevos datos en la tabla desastres_bde.desastres_final
  INSERT INTO desastres_bde.dbo.desastres_final (Cuatrenio, Temp_AVG, Oxi_AVG, T_Tsunamis, T_OlasCalor, T_Terremotos, T_Erupciones, T_Incendios, M_Jovenes_AVG, M_Adutos_AVG, M_Ancianos_AVG)
  SELECT 
    CASE c.año
      WHEN '2023' THEN '2023-2026'
      WHEN '2024' THEN '2023-2026'
      WHEN '2025' THEN '2023-2026'
      WHEN '2026' THEN '2023-2026'
      WHEN '2027' THEN '2027-2030'
      WHEN '2028' THEN '2027-2030'
      WHEN '2029' THEN '2027-2030'
      WHEN '2030' THEN '2027-2030'
    END AS Cuatrenio,
    AVG(c.temperatura) AS Temp_AVG,
    AVG(c.oxigeno) AS Oxi_AVG,
    SUM(d.tsunamis) AS T_Tsunamis,
    SUM(d.Olas_Calor) AS T_OlasCalor,
    SUM(d.Terremotos) AS T_Terremotos,
    SUM(d.Erupciones) AS T_Erupciones,
    SUM(d.Incendios) AS T_Incendios,
    AVG(R_Menor15 + R_15_a_30) AS M_Jovenes_AVG,
    AVG(R_30_a_45 + R_45_a_60) AS M_Adutos_AVG,
    AVG(R_M_a_60) AS M_Ancianos_AVG
  FROM desastres.dbo.clima AS c
  JOIN desastres.dbo.desastres AS d ON c.año = d.año
  JOIN desastres.dbo.muertes AS m ON c.año = m.año
  GROUP BY
    CASE c.año
      WHEN '2023' THEN '2023-2026'
      WHEN '2024' THEN '2023-2026'
      WHEN '2025' THEN '2023-2026'
      WHEN '2026' THEN '2023-2026'
      WHEN '2027' THEN '2027-2030'
      WHEN '2028' THEN '2027-2030'
      WHEN '2029' THEN '2027-2030'
      WHEN '2030' THEN '2027-2030'
    END;
END;


-- Para borrar el procedimiento
--DROP PROCEDURE IF EXISTS pETL_Desastres;

--------------------------------

/*PASO 4: EJECUTRAR PROCEDIMIENTO*/

-- Llamar al procedimiento almacenado en SQL Server
EXEC pETL_Desastres;

select*from desastres_bde.dbo.desastres_final;