INSERT into category
SELECT distinct category from titleprincipals;

INSERT into titletype
SELECT distinct titleType FROM titlebasics;

INSERT into genre
SELECT distinct gen.[value] FROM titlebasics CROSS APPLY string_split(genres, ',') gen WHERE genres != '\N';

INSERT into profession
SELECT distinct prof.[value] from namebasics CROSS APPLY string_split(primaryProfession, ',') prof;

SELECT distinct nconst, primaryname, birthyear, deathyear FROM namebasics;