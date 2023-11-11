--FORMA CORTA PARA VISUALIZAR PERMISOS EN REDSHIFT

SELECT
    u.usename,
    s.schemaname,
    has_schema_privilege(u.usename,s.schemaname,'create') AS user_has_select_permission,
    has_schema_privilege(u.usename,s.schemaname,'usage') AS user_has_usage_permission
FROM
    pg_user u
CROSS JOIN
    (SELECT DISTINCT schemaname FROM pg_tables) s
WHERE
    u.usename = 'ariel_chumbita_coderhouse'
    AND s.schemaname = 'ariel_chumbita_coderhouse'
    
 --Salida: si da V es que tiennes acceso.
    
    
    --FORMA COMPLEJA DE VISUALIZAR PERMISOS EN REDSHIFT
SELECT
    u.usename,
    t.schemaname||'.'||t.tablename,
    has_table_privilege(u.usename,t.tablename,'select') AS user_has_select_permission,
    has_table_privilege(u.usename,t.tablename,'insert') AS user_has_insert_permission,
    has_table_privilege(u.usename,t.tablename,'update') AS user_has_update_permission,
    has_table_privilege(u.usename,t.tablename,'delete') AS user_has_delete_permission,
    has_table_privilege(u.usename,t.tablename,'references') AS user_has_references_permission
FROM
    pg_user u
CROSS JOIN
    pg_tables t
WHERE
    u.usename = 'ariel_chumbita_coderhouse'
    --AND s.schemaname = 'ariel_chumbita_coderhouse'
