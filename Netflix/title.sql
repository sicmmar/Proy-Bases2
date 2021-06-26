select TOP 3 title.id 'titulo', tt.name 'tipo', primaryTitle, originalTitle, isAdult, startYear, endYear, runtime, n.primaryName, p.[character]
from title INNER JOIN titletype tt on titleTypeId = tt.id INNER JOIN principal p on title.id = p.titleId
INNER JOIN name n on p.nameId = n.id INNER JOIN category cat ON p.categoryId = cat.id
where primaryTitle = 'Frozen'
and tt.name = 'movie' and startYear = 2013 and (cat.name = 'actress' or cat.name = 'actor');