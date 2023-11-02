drop table ariel_chumbita_coderhouse.prueba;

--Crear tabla en Redshift
create table ariel_chumbita_coderhouse.prueba (
nombre varchar(25) null,
apellido varchar(25) null
)

--Insertar registros
insert into ariel_chumbita_coderhouse.prueba values ('Ariel', 'Chumbita')

--Consultar tabla
explain select*from ariel_chumbita_coderhouse.prueba


-----------------------------------------------
--CONEXIÓN API PUBLICAS
CREATE DATABASE FINANZAS;