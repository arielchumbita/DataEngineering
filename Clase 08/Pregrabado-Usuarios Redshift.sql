--CREAR USUARIOS EN REDSHIFT

--Usuario sin contraseña y sin fecha de fin
create user ariel password disable valid until 'infinity'

--Usuario con contraseña y fecha de fin:
create user alberto with password '1234abcD' valid until '2022-12-10'

--Crear superusuario:
alter user david createuser

--DAR O DENEGAR PERMISOS A USUARIOS

--GRANT - Otorgar permisos:
--Permiso de lectura a un usuario especifico a tabla previamente creada:
grant select on table clientes to david

--Permiso de insert, drop, update:
grant all on table clientes to david

--REVOKE - Denegar permisos:
--Denegar permiso de consulta de la tabla:
revoke select on table clientes from david


--CREAR GRUPOS EN AMAZON REDSHIFT:
--Crear grupo recursos humanos:
create group rh with user david
--Agrego otro usuario al grupo ya creado:
alter group rh add user alberto

--CREAR ROL EN AMAZON REDSHIFT:
--Crear rol
create role rol_ejemplo_rh

--Doy permiso de uso a este grupo específico:
grant references on clientes to group rh

--Doy todos los permisos
grant all on clientes to group rh


--ENCRIPTACIÓN EN REDSHIFT
--MASKING ESTÁTICO
select
    name,
    sha2(name, 256) as name enc,
    email,
    regexp_replace(email, '[@]+@', '*@') as email_enc
from test_coder

--MASKING SOBRE UNA VISTA
--Vista encriptada (No tengo que preparar datos)
create or replace view nombre_encriptado as 
    select
        name,
        sha2(name, 256) as name enc,
        email,
        regexp_replace(email, '[@]+@', '*@') as email_enc
    from test_coder

--MASKING DINÁMICO:
create view prueba_masking as
    select
    case when current_user = 'admin' then sha2(name, 256) end as name_enc,
    case when current_user = 'admin' then regexp_replace(email, '[@]+@', '*@')end as email_enc
    from test_coder

--CARGA DATOS AMAZON REDSHIFT
COPY nombre_tabla FROM fuente_datos autorizacion

--Ejemplo
COPY clientes
FROM 's3://<nombre_bucket>/clientes.json'
credentials 'aws_iam_role=aim_<aws-account-id>:role/Redshift'
json 'auto'

--ETL MANUALES - de “redshift” a “s3”
UNLOAD ("select*from public.users)
to "s3://redshifttickitdata/unload_result/" --Ubicación donde se van a ubicar los datos
iam_role "arn:aws:iam::<account_id>: role/Redshift-S3-DynamoDB-EC2-Access-role"
CSV --Especificar formato archivo a exportar

--Comprimido
UNLOAD ("select*from public.users)
to "s3://redshifttickitdata/unload_result/" --Ubicación
iam_role "arn:aws:iam::<account_id>: role/Redshift-S3-DynamoDB-EC2-Access-role"
CSV GZIP PARALLEL OFF --Para comprimir y desactivar modo exportación en paralelo

--EXPORTAR EN VARIOS ARCHIVOS
UNLOAD ("select*from public.users)
to "s3://redshifttickitdata/unload_result/"
iam_role "arn:aws:iam::<account_id>: role/Redshift-S3-DynamoDB-EC2-Access-role"
PARTITION BY (estado) --Valores de columna estado
FORMAT PARQUET --Exporto en formato parquet