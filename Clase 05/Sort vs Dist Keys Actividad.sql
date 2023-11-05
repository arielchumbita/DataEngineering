-- Contexto tipico
agents: agentid (primary key)

calls: callid (primary key), agentid (foreign key), productsold (index), customerid (foreign key)

customers: customerid (primary key), email (index), phonenumber (index)

-- Sort y distribution keys

agents:
Para la tabla de agentes, la distkey debe elegirse en función de cómo se consultan y unen los datos 
comúnmente. Si la tabla generalmente se une a la tabla de calls mediante la columna agentid, puede
 tener sentido usar agentid como distkey. Si la tabla se busca más a menudo por nombre, el nombre 
 podría ser una mejor opción. La sortkey de esta tabla podría ser el nombre, ya que permitiría una
  ordenación eficaz de los datos cuando se soliciten.

calls:
Para la tabla de calls, la distkey debe ser la columna de clave externa agentid, que la vincula 
a la tabla de agents. Esto garantiza que todos los datos de un agente determinado se almacenen en el 
mismo nodo, lo que puede mejorar el rendimiento de las consultas. La sortkey para esta tabla podría ser
 la columna pickedup, ya que las consultas a menudo necesitan filtrar por esta columna.

customers:
Para la tabla de customers, la distkey debe ser la columna de identificación del cliente, ya que esta
 es la clave principal e identifica de forma única cada fila. La sortkey podría ser la columna de nombre,
  ya que permitiría una ordenación eficiente de los datos cuando se consultan.

En resumen

agents: agentid (distribution key), name (sort key)
calls: agentid (distribution key), pickedup (sort key)
customers: customerid (distribution key), name (sort key)


-- SQL
-- Create the agents table
create table ariel_chumbita_coderhouse.agentsx (
agentid INTEGER PRIMARY KEY,
name VARCHAR(50)
)
DISTSTYLE ALL --Reparte tabla en todos los notos, replica en cada nodo. Al no ser pesada.
SORTKEY(name);


-- Create the calls table
CREATE TABLE ariel_chumbita_coderhouse.callsx (
    callid INTEGER PRIMARY KEY,
    agentid INTEGER REFERENCES agents(agentid),
    customerid INTEGER,
    pickedup TIMESTAMP,
    duration INTEGER,
    productsold VARCHAR(50)
)
DISTSTYLE KEY
DISTKEY(agentid)
SORTKEY(pickedup);


-- Create the customers table
CREATE TABLE ariel_chumbita_coderhouse.customersx (
    customerid INTEGER PRIMARY KEY,
    name VARCHAR(50),
    occupation VARCHAR(50),
    email VARCHAR(50),
    company VARCHAR(50),
    phonenumber VARCHAR(50),
    age INTEGER
)
DISTSTYLE KEY
DISTKEY(customerid)
SORTKEY(name);


El parámetro DISTSTYLE determina el estilo de distribución de los datos de la tabla entre los nodos. 
La opción DISTSTYLE ALL replica la tabla en todos los nodos, mientras que la opción DISTSTYLE KEY 
distribuye los datos en función de una columna de clave de distribución seleccionada. 
La opción DISTSTYLE EVEN distribuye los datos uniformemente entre todos los nodos.

El parámetro DISTKEY especifica la columna de clave de distribución para tablas con un estilo de 
distribución DISTSTYLE KEY. Esto determina cómo se dividen los datos entre los nodos.
SE USA MUCHO EN JOINS

El parámetro SORTKEY especifica las columnas de clave de clasificación de la tabla, 
lo que puede mejorar el rendimiento de las consultas al optimizar el orden de los
datos en el disco.

SE USA MUCHO EN WHERE