create database Booklet;

/*drop table agents;
drop table customers;
drop table calls;*/

--CREO TABLAS--
create table agents (
	agentID int not null primary key,
	name varchar(50) not null);

create table customers (
	customerID int not null primary key ,
	name varchar(50) not null,
	occupation varchar(50) not null,
	email varchar(50) not null,
	company varchar(50) not null,
	phonenumber varchar(50) not null,
	age int not null);

create table calls (
	callID int not null primary key,
	agentID int not null,
	customerID int not null,
	pickedup int not null,
	duration int not null,
	productsold int not null,
	CONSTRAINT fk_agents_calls FOREIGN KEY (agentID) REFERENCES agents(agentID),
	CONSTRAINT fk_customers_calls FOREIGN KEY (customerID) REFERENCES customers(customerID));

/*AGREGO DATOS*/
--Previo a esto debo eliminar título de los campos en el archivo csv.
--Corroborar que los tipos de datos sean correctos.
--Observar delimitador si es el correcto ya sea coma o punto y coma.
--Ojo que no haya campos donde tenga coma por ejemplo un nombre y apellido separado por coma.

BULK INSERT agents
FROM 'G:\Usuarios\Ariel Chumbita\Desktop\ARIEL\CURSOS Y FORMACION\DATA ENGINEERING - CODER HOUSE\Booklet\agents.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');

BULK INSERT customers
FROM 'G:\Usuarios\Ariel Chumbita\Desktop\ARIEL\CURSOS Y FORMACION\DATA ENGINEERING - CODER HOUSE\Booklet\customers.csv'
WITH (FIELDTERMINATOR = ';', ROWTERMINATOR = '\n');

BULK INSERT calls
FROM 'G:\Usuarios\Ariel Chumbita\Desktop\ARIEL\CURSOS Y FORMACION\DATA ENGINEERING - CODER HOUSE\Booklet\calls.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');

select*from agents;
select*from customers;
select*from calls;

------------------------------------------------------------

/*EJERCICIO 1*/
select * from agents
where name like 'M%' or name like '%o';

/*EJERCICIO 2*/
select distinct occupation
from customers
where occupation like '%Engineer%'
order by occupation;

/*EJERCICIO 3*/
select customerid, name,
case
	when age>=30 then 'SI'
	when age<30 then 'NO'
	else 'Missing Data'
	end as Mayor30
from customers
order by name desc;

/*EJERCICIO 4*/
select*from calls
select*from customers;

--

select name, callID, agentID, calls.customerID, pickedup, duration,
case
	when age>=30 then 'SI'
	when age<30 then 'NO'
	else 'Missing Data'
	end as 'Mayor30',
case
	when productsold=1 then 'COMPRO'
	when productsold=0 then 'NO COMPRO'
	else 'Missing Data'
	end as 'Solddddd'
from calls
join customers
on calls.customerID=customers.customerID
where occupation like '%Engineer%';

/*EJERCICIO 5*/
select*from calls
select*from customers;

select sum (productsold) as 'Ventas Totales',
count (callID) as 'Llamadas Totales'
from calls
join customers
on calls.customerID=customers.customerID
where occupation like '%Engineer%';

select sum (productsold) as 'Ventas Totales',
count (callID) as 'Llamadas Totales'
from calls
join customers
on calls.customerID=customers.customerID;

--Resolución Coder--
select sum(productsold) as 'TotalSales',
count(*) as NCalls
from customers
join calls
on calls.customerID=customers.customerID
where occupation like '%Engineer%';

/*EJERCICIO 6*/
select*from agents;
select*from calls
select*from customers;

select name as 'AgentName',
count (callID) as 'NCalls',
max (duration) as 'Longest',
min (duration) as 'Shortest',
avg (duration) as 'AvgDuration',
sum (productsold) as 'TotalSales'
from agents
join calls
on calls.agentID=agents.agentID
where pickedup=1
group by name
Order by AgentName;

/*EJERCICIO 7*/
select*from agents;
select*from calls
select*from customers;

select name as 'AgentName',
sum (
	case
		when productsold=1 then duration
		else 0
	end)/sum(
		case
			when productsold=1 then 1
			else 0
		end)
as 'AvgDurationSold',
sum (
	case
		when productsold=0 then duration
		else 0
	end)/sum(
		case
			when productsold=0 then 1
			else 0
		end)
as 'AvgDurationLost'
from agents
join calls
on calls.agentID=agents.agentID
group by name
Order by name;
