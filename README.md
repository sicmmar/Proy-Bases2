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

El script de la inserción en la base de datos se encuentra en el archivo [```IMDB/insert.sql```](#https://github.com/sicmmar/Proy-Bases2/blob/main/IMDB/insert.sql)

# Netflix
Para la base de datos de este sistema, se desarrolló en SQL Server en un contenedor de Docker.

## Modelado de Datos

El modelo entidad relación surge a partir del diagrama de [IMDB](#imdb), pero para la base de datos de Netflix se reduce al siguiente diagrama

![](img/er-net.png)

### Tablas

|Tabla|Explicación|
|:--:|:--:|
|Genre|En esta tabla se almacenan los géneros posibles de algún título|
|TitleType|Se almacenan los posibles tipos de un título. Ej. Show, película, serie, etc.|
|Title|En esta tabla se almacena la información relevante de un título y en ella también hace referencia con llave foránea hacia los posibles tipos de títulos y géneros que pueda clasificarse un mismo título.|
|Title_Genre|A esta tabla caen todos los géneros posibles en los que pueda clasificarse un mismo título.|
|Episode|En dado caso el título sea una serie, acá se encuentra a detalle su único o varios episodios correspondientes a un mismo título|
|Person|Esta tabla almacena todas las personas que pueden verse enrrollada en algún título|
|Role|Acá se especifican los posibles roles que las personas pueden ejercer. Éstos pueden ser actor, actriz, director o escritor|
|Crew|Acá se definen todas las personas y rol que ejercen en un mismo título|