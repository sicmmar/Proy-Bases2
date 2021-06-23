create table genre(
    id int IDENTITY(1,1),
    name VARCHAR(75),
    PRIMARY KEY (id)
);

CREATE TABLE titletype(
    id int IDENTITY(1,1),
    name VARCHAR(75),
    PRIMARY KEY(id)
);

CREATE TABLE title(
    id VARCHAR(45),
    titleTypeId int,
    primaryTitle VARCHAR(115),
    originalTitle VARCHAR(115),
    isAdult int,
    startYear int,
    endYear int,
    runtime int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleTypeId) REFERENCES titletype(id)
);

CREATE TABLE titleGenre(
    titleId VARCHAR(45),
    genreId int,
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (genreId) REFERENCES genre(id)
);

CREATE TABLE name(
    id VARCHAR(45),
    primaryName VARCHAR(115),
    birthYear int,
    deathYear int,
    PRIMARY KEY (id)
);

CREATE TABLE profession(
    id int IDENTITY(1,1),
    name VARCHAR(115),
    PRIMARY KEY(id)
);

CREATE TABLE nameProfession(
    nameId VARCHAR(45),
    professionId int,
    FOREIGN KEY(nameId) REFERENCES name(id),
    FOREIGN KEY(professionId) REFERENCES profession(id)
);

CREATE TABLE category(
    id int IDENTITY(1,1),
    name varchar(115),
    PRIMARY KEY(id)
);

CREATE TABLE principal(
    id int IDENTITY(1,1),
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    categoryId int,
    jobId VARCHAR(115),
    orden VARCHAR(45),
    character VARCHAR(45),
    PRIMARY KEY (id),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (categoryId) REFERENCES category(id)
);

CREATE TABLE knowForTitle(
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE director(
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE writer(
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE rating(
    id int IDENTITY(1,1),
    titleId VARCHAR(45),
    averageRating DECIMAL,
    numVotes int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE episode(
    id int IDENTITY(1,1),
    titleId VARCHAR(45),
    parentId VARCHAR(45),
    season int,
    episode int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (parentId) REFERENCES title(id)
);