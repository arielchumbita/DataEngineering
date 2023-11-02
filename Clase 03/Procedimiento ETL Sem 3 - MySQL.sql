drop database BDE;
drop database BDE_DW;

/*PASO 1: CREAR BASE DE DATOS DE ORIGEN*/
CREATE DATABASE BDE ;
USE BDE;

create table bde.titulos(
titulo_id CHAR(6) NOT NULL,
titulo varchar(80) NOT NULL,
tipo char(20) NOT NULL
);

INSERT INTO bde.titulos VALUES ('1', 'Consultas SQL','bbdd');
INSERT INTO bde.titulos VALUES ('3', 'Grupo recursos Azure','administracion');
INSERT INTO bde.titulos VALUES ('4', '.NET Framework 4.5','programacion');
INSERT INTO bde.titulos VALUES ('5', 'Programacion C#','dev');
INSERT INTO bde.titulos VALUES ('7', 'Power BI','BI');
INSERT INTO bde.titulos VALUES ('8', 'Administracion Sql server','administracion');

select * from bde.titulos;

CREATE TABLE bde.autores (
TituloId CHAR(6) NOT NULL,
NombreAutor VARCHAR(100) NOT NULL,
ApellidosAutor VARCHAR(100) NOT NULL,
TelefonoAutor VARCHAR(25)
);

INSERT INTO bde.autores VALUES ('3', 'David', 'Saenz', '99897867');
INSERT INTO bde.autores VALUES ('8', 'Ana', 'Ruiz', '99897466');
INSERT INTO bde.autores VALUES ('2', 'Julian', 'Perez', '99897174');
INSERT INTO bde.autores VALUES ('1', 'Andres', 'Calamaro', '99876869');
INSERT INTO bde.autores VALUES ('4', 'Cidys', 'Castillo', '998987453');
INSERT INTO bde.autores VALUES ('5', 'Pedro', 'Molina', '99891768');

select * from bde.autores;

--------------------------------

/*PASO 2: CREAR BASE DE DATOS DATA WAREHOUSE*/
create database BDE_DW;

use bde_dw;

CREATE TABLE bde_dw.DimTitulos (
TituloId CHAR(6) NOT NULL,
TituloNombre VARCHAR(100) NOT NULL,
TituloTipo VARCHAR(100) NOT NULL,
NombreCompleto VARCHAR(200),
TelefonoAutor VARCHAR(25)
);

select*from bde_dw.dimtitulos;

--------------------------------

/*PASO 3: CREAR EL PROCEDIMIENTO EN LA BASE DE ORIGEN*/
USE bde;

-- El DELIMITER $$ in MYSQL es importante a la hora de crear procedimientos

DELIMITER $$
CREATE PROCEDURE pETL_Insertar_DimTitulo()
BEGIN
  DELETE FROM bde_dw.dimtitulos; /*Vacio tabla*/
  INSERT INTO bde_dw.dimtitulos
    SELECT 
      t.titulo_id AS TituloId,
      t.titulo AS TituloNombre,
      CASE t.tipo
        WHEN 'bbdd' THEN 'Base de datos, Transact-SQL'
        WHEN 'BI' THEN 'Base de datos, BI'
        WHEN 'administracion' THEN 'Base de datos, Administracion'
        WHEN 'dev' THEN 'Desarrollo'
        WHEN 'programacion' THEN 'Desarrollo'
      END AS TituloTipo,
      CONCAT(a.NombreAutor, ' ', a.ApellidosAutor) AS NombreCompleto,
      a.TelefonoAutor
    FROM bde.titulos AS t
    JOIN bde.autores AS a ON t.titulo_id = a.TituloId;
END $$
DELIMITER ;

--------------------------------

/*PASO 4: EJECUTRAR PROCEDIMIENTO*/
-- Desactivar safe updates mode solo para MySQL cuando hago insersionces
SET SQL_SAFE_UPDATES=0;

-- Llamo al procedimiento
CALL pETL_Insertar_DimTitulo();

select * from bde_dw.dimtitulos;