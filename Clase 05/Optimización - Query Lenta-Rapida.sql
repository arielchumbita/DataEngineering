---------------------------------
--CREACION DE TABLAS
-- Momento 1 (creacion de tablas)
CREATE TABLE customers(
    customerid INT primary key,
    name VARCHAR(50),
    occupation VARCHAR(50),
    email VARCHAR(50),
    company VARCHAR(50),
    phonenumber VARCHAR(20),
    age INT
);

CREATE TABLE agents(
    agentid INT primary key,
    name VARCHAR(50)
);

CREATE TABLE calls(
    callid INT primary key,
    agentid INT,
    customerid INT,
    pickedup SMALLINT,
    duration INT,
    productsold SMALLINT
);

-- Llenar con los csv >> Click derecho > Import data elegir los csv
----------------------------
select*from calls
select*from agents
select*from customers
----------------------------


-- CONSULTA LENTA
SELECT * FROM
(SELECT ca.agentid, ca.duration, max(customerid) AS customerid
   FROM
   (
       SELECT agentid, min(duration) as fastestcall
       FROM calls
       WHERE productsold = 1
       GROUP BY agentid
   ) min
   JOIN calls ca ON ca.agentid = min.agentid AND ca.duration = min.fastestcall
   JOIN agents a ON ca.agentid = a.agentid
   WHERE productsold = 1
   GROUP BY ca.agentid, ca.duration) as x
   LEFT JOIN customers cu on x.customerid= cu.customerid
   
   
   -- CONSULTA RÁPIDA
   
SELECT a.name AS AgentName, cu.name AS CustomerName, x.duration
FROM
(
   SELECT ca.agentid, ca.duration, max(customerid) AS cid
   FROM
   (
       SELECT agentid, min(duration) as fastestcall
       FROM calls
       WHERE productsold = 1
       GROUP BY agentid
   ) min
   JOIN calls ca ON ca.agentid = min.agentid AND ca.duration = min.fastestcall
   WHERE productsold = 1
   GROUP BY ca.agentid, ca.duration
) x
JOIN agents a ON x.agentid = a.agentid
JOIN customers cu ON cu.customerid = x.cid
OPTION (QUERYTRACEON 8649)