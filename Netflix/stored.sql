CREATE PROCEDURE insert_title 
    @titulo varchar(600), 
    @anio int, 
    @tipo_titulo int, 
    @desc varchar(5000)
AS
    DECLARE @id_title VARCHAR(115);

    SET @id_title = (
        SELECT TOP 1 tl.id FROM [192.168.1.2].IMDB.dbo.title tl
        WHERE UPPER(tl.primaryTitle) = UPPER(@titulo) AND tl.startYear = @anio AND tl.titleTypeId = @tipo_titulo
    );

    IF @id_title IS NULL
        BEGIN
            -- SIGNIFICA QUE EL TITULO NO ESTA EN EL CATALOGO DE IMDB
            RETURN(1)
        END
    ELSE
        BEGIN
            -- INSERTAR A LA TABLA TITLE
            INSERT INTO title(id, primaryTitle, isAdult, startYear, endYear, runtime, [description], titleTypeId)
            SELECT TOP 1 tl.id, tl.primaryTitle, tl.isAdult, tl.startYear, tl.endYear, tl.runtime, @desc, tl.titleTypeId
            FROM [192.168.1.2].IMDB.dbo.title tl WHERE tl.id = @id_title;

            -- INSERTAR A LA TABLA CREW
            INSERT INTO crew(titleId, personId, roleId)
            SELECT TOP 3 pr.titleId, pr.nameId, role.id
            FROM [192.168.1.2].IMDB.dbo.principal pr INNER JOIN [192.168.1.2].IMDB.dbo.category cg ON pr.categoryId = cg.id
            INNER JOIN role ON role.name = cg.name
            WHERE pr.titleId = @id_title AND (cg.name = 'actor' OR cg.name = 'actress');

            INSERT INTO crew(titleId, personId, roleId)
            SELECT TOP 1 dr.titleId, dr.nameId, role.id
            FROM [192.168.1.2].IMDB.dbo.director dr, role 
            WHERE dr.titleId = @id_title AND role.name = 'director';

            INSERT INTO crew(titleId, personId, roleId)
            SELECT TOP 1 dr.titleId, dr.nameId, role.id
            FROM [192.168.1.2].IMDB.dbo.director dr, role 
            WHERE dr.titleId = @id_title AND role.name = 'writer';

            -- INSERTAR A LA TABLA EPISODE
            IF (SELECT count(*) FROM [192.168.1.2].IMDB.dbo.episode ep WHERE ep.parentId = @id_title) > 0
                BEGIN
                    INSERT INTO episode(titleId, parentId, season, episode)
                    SELECT ep.titleId, ep.parentId, ep.season, ep.episode
                    FROM [192.168.1.2].IMDB.dbo.episode ep WHERE ep.parentId = @id_title;
                END

            RETURN(0)
        END
GO

--drop PROCEDURE insert_title;

EXEC insert_title 'Frozen',200013,9,'Elsa found her power';

SELECT * FROM title;