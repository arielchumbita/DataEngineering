--CREO TABLA CLIMA
--drop table data_clima_sem7

CREATE TABLE data_clima_sem7 (
    Sea_Level FLOAT,
    Wheater INT,
    Temperatures INT,
    Carbon_Dioxide INT,
    Global_Warming INT,
    Country VARCHAR(2),
    Fecha DATE
);

select *from data_clima_sem7;

--EJECUTO EL CÓDIGO EN PYTHON QUE ENVÍA LA INFORMACIÓN A REDSHIFT
--Luego realizo nuevamente la consulta y verifico la ingesta de los datos.
select *from data_clima_sem7;

--INGESTO PAISES POR SEPARADOS
