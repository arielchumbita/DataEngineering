-- Momento 1
CREATE SCHEMA my_secure_schema;

CREATE TABLE my_secure_schema.my_secure_table (
name VARCHAR(30),
dob TIMESTAMP SORTKEY,
zip INTEGER,
ssn VARCHAR(9)
)
diststyle all;

-- Momento 2
CREATE USER data_scientist PASSWORD 'Test1234';

CREATE GROUP ds_prod WITH USER data_scientist;

-- Momento 3
SELECT * FROM my_secure_schema.my_secure_table;


--- Verificar si tiene acceso al esquema
SELECT schema_name FROM information_schema.schemata  --Consulto permisos para un usuario
WHERE schema_owner = 'data_scientist';

-- Verificar todos mis esquemas
SELECT schema_name FROM information_schema.schemata 
WHERE schema_owner = 'dafbustosus_coderhouse';

-- ver todos los usuarios
SELECT usename FROM pg_user

-- Ver permisos del usuario
SELECT grantee, privilege_type 
FROM information_schema.table_privileges 
WHERE grantee = 'data_scientist';


-----------SEGURIDAD COLUMNAS-----------

-- Momento 1: Otorgar acceso al usuario para todas las columnas, excepto el Número de Seguro Social (ssn) para el usuario
GRANT ALL ON SCHEMA my_secure_schema TO data_scientist; --Acceso al esquema
GRANT SELECT(name, dob, zip) ON my_secure_schema.my_secure_table TO data_scientist; --Acceso a parte de la tabla

REVOKE ALL ON SCHEMA my_secure_schema TO data_scientist; --Quito acceso al esquema

-- Momento 2: Conectarse al clúster con usuario data_scientist. 
-- Ejecute una selección en la tabla con y sin el Número de Seguro Social. Observen la diferencia
SELECT name, dob, zip
FROM my_secure_schema.my_secure_table;

SELECT name, dob, zip, ssn
FROM my_secure_schema.my_secure_table;

--La primera consulta debera arrojar 0 filas mientras que la segunda mostrara un error
