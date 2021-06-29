select TOP 3 title.id 'titulo', tt.name 'tipo', primaryTitle, originalTitle, isAdult, startYear, endYear, runtime, n.primaryName, p.[character]
from title INNER JOIN titletype tt on titleTypeId = tt.id INNER JOIN principal p on title.id = p.titleId
INNER JOIN name n on p.nameId = n.id INNER JOIN category cat ON p.categoryId = cat.id
where primaryTitle = 'Frozen'
and tt.name = 'movie' and startYear = 2013 and (cat.name = 'actress' or cat.name = 'actor');

SELECT * FROM [192.168.1.2].IMDB.dbo.title tl INNER JOIN [192.168.1.2].IMDB.dbo.titletype ty ON tl.titleTypeId = ty.id
WHERE UPPER(tl.primaryTitle) LIKE UPPER('%Vis%');

SELECT * FROM title;

-- INSERT TITLE
SELECT TOP 1 tl.id, tl.primaryTitle, tl.isAdult, tl.startYear, tl.endYear, tl.runtime, 'descrip', ty.id
FROM [192.168.1.2].IMDB.dbo.title tl INNER JOIN [192.168.1.2].IMDB.dbo.titletype ty ON tl.titleTypeId = ty.id
WHERE UPPER(tl.primaryTitle) = UPPER('Friends') AND tl.startYear = 1994 AND tl.titleTypeId = 1;

SELECT TOP 1 tl.id, tl.primaryTitle, tl.isAdult, tl.startYear, tl.endYear, tl.runtime, 'descrip', tl.titleTypeId
FROM [192.168.1.2].IMDB.dbo.title tl WHERE tl.id = 'tt2294629'

-- INSERT CREW -> ELENCO
SELECT TOP 3 pr.titleId, pr.nameId, role.id
FROM [192.168.1.2].IMDB.dbo.principal pr INNER JOIN [192.168.1.2].IMDB.dbo.category cg ON pr.categoryId = cg.id
INNER JOIN role ON role.name = cg.name
WHERE pr.titleId = 'tt2294629' AND (cg.name = 'actor' OR cg.name = 'actress');

-- INSERT CREW -> DIRECTOR
SELECT TOP 1 dr.titleId, dr.nameId, role.id
FROM [192.168.1.2].IMDB.dbo.director dr, role 
WHERE dr.titleId = 'tt2294629' AND role.name = 'director';

-- INSERT CREW -> DIRECTOR
SELECT TOP 1 dr.titleId, dr.nameId, role.id
FROM [192.168.1.2].IMDB.dbo.director dr, role 
WHERE dr.titleId = 'tt2294629' AND role.name = 'writer';

SELECT ep.titleId, ep.parentId, ep.season, ep.episode
FROM [192.168.1.2].IMDB.dbo.episode ep WHERE ep.parentId = 'tt0108778';

SELECT * FROM [192.168.1.2].IMDB.dbo.title tt WHERE tt.id = 'tt0583432';