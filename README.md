# Proyecto
Proyecto implementado para Bases de Datos 2

Desarrollado por: **_Asunción Mariana Sic Sor_**

# Tabla de Contenido

* [IMDB](#imdb)
    * [Carga de Datos](#carga-datos)
    * [Creación de Tablas](#creación-inserción-tablas)
* [Netflix](#netflix)
    * [Modelado de Datos](#modelado-de-datos)
        * [Explicación de Tablas](#tablas)
    * [Inserción a Netflix](#inserción-a-netflix)
        * [Linked Server](#linked-server)
* [Mongo](#mongo)

# IMDB

Esta base de datos se desarrolló en un servidor con Sistema Operativo Arch Linux (Manjaro KFCE)

El modelo Entidad-Relacional es el siguiente

![](img/er-imdb.png)

Esta base de datos se ha desarollado en SQL Server y los datos se encuentran en este [enlace](https://drive.google.com/drive/u/1/folders/1FtmfuvnxwSpXAHLT0jTK3bSCRztVrXDr).

## Carga Datos

Para cargar dichos datos, se crea una tabla temporal por cada archivo ```.tsv``` de la siguiente manera

> Para el procedimiento se utiliza el archivo ```namebasics.tsv```

Primero se crea la tabla temporal para almacenar los datos

```sql
CREATE TABLE namebasics(
    nconst VARCHAR(115),
    primaryname VARCHAR(115),
    birthyear VARCHAR(45),
    deathyear VARCHAR(45),
    primaryProfession VARCHAR(115),
    knownforTitles VARCHAR(115)
);
```

Luego se insertan los datos con la siguiente instrucción
```sql
BULK INSERT namebasics
FROM '/namebasics.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);
```

Y los datos se cargaran

![](img/tsv-imdb.png)

Dicho procedimiento se ejecuta para todos los archivos proporcionados

## Creación-Inserción Tablas

Luego se crean las tablas según el [modelo entidad/relación](#modelo-er) correspondiente.

>Por ejemplo, se muestra con la tabla ```Category```

Se crea la tabla

```sql
create table genre(
    id int IDENTITY(1,1),
    name VARCHAR(75),
    PRIMARY KEY (id)
);
```

Luego con una consulta a la base de datos de la tabla temporal ```titleprincipals``` se inserta a la tabla

```sql
INSERT into category
SELECT distinct category from titleprincipals;
```

Y ya quedan insertados los datos en la base de datos

![](img/insert-imdb.png)

De esta manera se insertan los datos en la base de datos.

El script de la inserción en la base de datos se encuentra en el archivo [```IMDB/insert.sql```](IMDB/insert.sql)

# Netflix
Para la base de datos de este sistema, se desarrolló en SQL Server en una máquina virtual con [Xubuntu](https://xubuntu.org/) como Sistema Operativo

## Modelado de Datos

El modelo entidad relación surge a partir del diagrama de [IMDB](#imdb), pero para la base de datos de Netflix se reduce al siguiente diagrama

![](img/er-net.png)

> Su modelo relacional se encuentra [acá](img/er-rel-net.png)

### Tablas

|Tabla|Descripción|
|:--:|:--:|
|Genre|En esta tabla se almacenan los géneros posibles de algún título|
|TitleType|Se almacenan los posibles tipos de un título. Ej. Show, película, serie, etc.|
|Title|En esta tabla se almacena la información relevante de un título y en ella también hace referencia con llave foránea hacia los posibles tipos de títulos y géneros que pueda clasificarse un mismo título. El valor de esta llave primaria es exactamente igual a la de IMDB para poder vincular su rating|
|Title_Genre|A esta tabla caen todos los géneros posibles en los que pueda clasificarse un mismo título.|
|Episode|En dado caso el título sea una serie, acá se encuentra a detalle su único o varios episodios correspondientes a un mismo título|
|Person|Esta tabla almacena todas las personas que pueden verse enrrollada en algún título|
|Role|Acá se especifican los posibles roles que las personas pueden ejercer. Éstos pueden ser actor, actriz, director o escritor|
|Crew|Acá se definen todas las personas y rol que ejercen en un mismo título|

Se eligió dicho modelo basándose en los datos que actualmente muestra el catálogo de [Netflix &copy;](netflix.com)

![](img/ex-net.png)

> _**Fuente:** Esta imagen es propiedad de [Netflix &copy;](www.netflix.com) y en ella se muestra el título de [Vis a Vis](https://www.imdb.com/title/tt4524056/)_

La creación de las tablas descritas se encuentra en [```Netflix/create.sql```](Netflix/create.sql)

## Inserción a Netflix



### Linked Service

Para estar insertando nuevas películas en la base de datos de Netflix, se necesita un procedimiento almacenado y que la película que se vaya insertando cree un vínculo entre la base de datos IMDB con la de Netflix, dado que ambas están en diferente servidor, se crea un [Linked Server](https://docs.microsoft.com/en-us/sql/relational-databases/linked-servers/create-linked-servers-sql-server-database-engine?view=sql-server-linux-ver15#TsqlProcedure) para conectar entre servidores.

El servicio enlazado se crea con la siguiente instrucción

```sql
USE [NETFLIX]
GO

EXEC sp_addlinkedserver
    @server = N'192.168.1.2',
    @srvproduct = N'SQL Server';
GO
```

La dirección IP ```192.168.1.2``` pertenece al servidor que aloja la base de datos de IMDB. Para verificar que se haya enlazado correctamente, se ejecuta la consulta 

```sql
SELECT name FROM [192.168.1.2].master.sys.databases;
```

Para rectificar que entre las bases de datos del otro servidor, se encuentre la de IMDB

![](img/linked.png)