--------------- PgAdmin ----------------------
CREATE TABLE customers2 (
name VARCHAR(255),
industry VARCHAR(255),
project1_id INTEGER,
project1_feedback TEXT,
project2_id INTEGER,
project2_feedback TEXT,
contact_person_id INTEGER,
contact_person_and_role VARCHAR(300),
phone_number VARCHAR(12),
address VARCHAR(255),
city VARCHAR(255),
zip VARCHAR(5)
);

-- SOLUCION 1NF
-- Agregar llave primaria
drop table customers2;

CREATE TABLE customers2 (
    id BIGSERIAL PRIMARY KEY, --AGREGO ID
    name VARCHAR(255),
    industry VARCHAR(255),
    project1_id INTEGER,
    project1_feedback TEXT,
    project2_id INTEGER,
    project2_feedback TEXT,
    contact_person_id INTEGER,
    contact_person_and_role VARCHAR(300),
    phone_number VARCHAR(12),
    address VARCHAR(255),
    city VARCHAR(255),
    zip VARCHAR(5)
);

-- Separar la columna contact_person_and_role
ALTER TABLE customers2
    RENAME COLUMN contact_person_and_role TO contact_person;
   
ALTER TABLE customers2
ADD COLUMN contact_person_role VARCHAR(300);

 --select * from customers2 c 

-- Mover las columnas project_ids y project_feedbacks a una nueva tabla project_feddbacks
-- En redshift hay que hacer los drop uno por uno
ALTER TABLE customers2
DROP COLUMN project1_id;

ALTER TABLE customers2
DROP COLUMN project1_feedback;

ALTER TABLE customers2
DROP COLUMN project2_id;

ALTER TABLE customers2
DROP COLUMN project2_feedback;

-- verificar
select * from customers2 c 


--------------Creo tabla para project_feedbacks---------------
CREATE TABLE project_feedbacks (
    id                  BIGSERIAL PRIMARY KEY,
    project_id          INTEGER,
    customer_id         INTEGER,
    project_feedback    TEXT
);

select * from project_feedbacks;



------------- Amazon Redshift---------------------
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'dafbustosus_coderhouse';

-- Crear tabla de origen
CREATE TABLE customers (
name VARCHAR(255),
industry VARCHAR(255),
project1_id INTEGER,
project1_feedback TEXT,
project2_id INTEGER,
project2_feedback TEXT,
contact_person_id INTEGER,
contact_person_and_role VARCHAR(300),
phone_number VARCHAR(12),
address VARCHAR(255),
city VARCHAR(255),
zip VARCHAR(5)
);

-- SOLUCION 1NF

-- Agregar llave primaria
drop table dafbustosus_coderhouse.customers;
CREATE TABLE dafbustosus_coderhouse.customers (
    id INTEGER IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    industry VARCHAR(255),
    project1_id INTEGER,
    project1_feedback TEXT,
    project2_id INTEGER,
    project2_feedback TEXT,
    contact_person_id INTEGER,
    contact_person_and_role VARCHAR(300),
    phone_number VARCHAR(12),
    address VARCHAR(255),
    city VARCHAR(255),
    zip VARCHAR(5)
);

-- Separar la columna contact_person_and_role
ALTER TABLE dafbustosus_coderhouse.customers
    RENAME COLUMN contact_person_and_role TO contact_person;

ALTER TABLE customers
ADD COLUMN contact_person_role VARCHAR(300);

-- Mover las columnas project_ids y project_feedbacks a una nueva tabla project_feddbacks
-- En redshift hay que hacer los drop uno por uno
ALTER TABLE dafbustosus_coderhouse.customers
DROP COLUMN project1_id;

ALTER TABLE dafbustosus_coderhouse.customers
DROP COLUMN project1_feedback;

ALTER TABLE dafbustosus_coderhouse.customers
DROP COLUMN project2_id;

ALTER TABLE dafbustosus_coderhouse.customers
DROP COLUMN project2_feedback;

-- verificar
select * from dafbustosus_coderhouse.customers c 

CREATE TABLE project_feedbacks (
    id                  INTEGER IDENTITY(1,1) PRIMARY KEY,
    project_id          INTEGER,
    customer_id         INTEGER,
    project_feedback    TEXT
);

select * from dafbustosus_coderhouse.project_feedbacks;

