CREATE PROCEDURE insert_title 
    @titulo varchar(600), 
    @anio int, 
    @tipo_titulo int, 
    @desc varchar(5000),
    @flag varchar(115) OUTPUT
AS
    DECLARE @id_title VARCHAR(115);

    SET @id_title = (
        SELECT TOP 1 tl.id FROM [192.168.1.2].IMDB.dbo.title tl
        WHERE UPPER(tl.primaryTitle) LIKE UPPER(@titulo) AND tl.startYear = @anio AND tl.titleTypeId = @tipo_titulo
    );

    IF @id_title IS NULL
        BEGIN
            -- SIGNIFICA QUE EL TITULO NO ESTA EN EL CATALOGO DE IMDB
            SET @flag = 'El título ' + @titulo + ' no se ha encontrado.';
            RETURN
        END
    
    ELSE
        BEGIN
            IF (SELECT primaryTitle FROM title t WHERE t.id = @id_title) IS NULL
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

                    -- INSERT TITLE_GENRE
                    INSERT INTO title_genre(titleId, genreId)
                    SELECT * FROM [192.168.1.2].IMDB.dbo.titleGenre g WHERE g.titleId = @id_title;

                    -- INSERTAR A LA TABLA EPISODE
                    IF (SELECT count(*) FROM [192.168.1.2].IMDB.dbo.episode ep WHERE ep.parentId = @id_title) > 0
                        BEGIN
                            INSERT INTO episode(titleId, parentId, season, episode)
                            SELECT ep.titleId, ep.parentId, ep.season, ep.episode
                            FROM [192.168.1.2].IMDB.dbo.episode ep WHERE ep.parentId = @id_title;
                        END

                    SET @flag = 'El título ' + @titulo + ' ha sido agregado.';
                    RETURN
                END
            ELSE
                BEGIN
                    SET @flag = 'El título ' + @titulo + ' ya ha sido agregado antes.';
                    RETURN
                END
        END
GO

-- drop PROCEDURE insert_title;

-- 1. tvSeries
-- 2. tvSpecial
-- 3. tvMovie
-- 4. tvShort
-- 5. tvMiniSeries
-- 6. videoGame
-- 7. video
-- 8. tvEpisode
-- 9. movie
-- 10. short

DECLARE @result VARCHAR(115);
EXEC insert_title 'Mulan',1998,9,'', @flag = @result OUTPUT;
SELECT @result 'Resultado';

SELECT * FROM title;



-- DELETE from episode;
-- delete from crew;
-- DELETE from title_genre;
-- DELETE from title;