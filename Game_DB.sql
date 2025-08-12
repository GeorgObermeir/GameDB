create database Game_DB


--Tabels erstellen
create Table Plattform
(pfID int identity (1,1) Primary key,
Plattform NVARCHAR(30) NOT NULL UNIQUE);

insert into Plattform (Plattform)
values
('PC'),
('PS5'),
('Xbox'),
('Switch'),
('Smartphone')

create Table Store
(stID int identity (1,1) Primary key,
Store NVARCHAR(30) NOT NULL UNIQUE);

Insert into Store (Store)
values 
('Steam'),
('EpicGames'),
('Origin'),
('Battle.net'),
('PlayStation Store'),
('Xbox Store'),
('Nintendo  Store'),
('Mobile Store')


CREATE TABLE Store_Plattform
(Store INT,
 Plattform INT,
 FOREIGN KEY (Store) REFERENCES Store (stID)
	ON DELETE CASCADE,
 FOREIGN KEY (Plattform) REFERENCES Plattform (pfID)
	ON DELETE CASCADE,
 PRIMARY KEY (Store, Plattform));

insert into Store_Plattform (Store, Plattform)
values
((Select stID  from Store WHERE Store = 'Battle.net'),(Select pfID from Plattform WHERE Plattform = 'PC')),
((Select stID  from Store WHERE Store = 'EpicGames'), (Select pfID from Plattform WHERE Plattform = 'PC')),
((Select stID  from Store WHERE Store = 'Mobile Store'), (Select pfID from Plattform WHERE Plattform = 'Smartphone')),
((Select stID  from Store WHERE Store = 'Nintendo  Store'),(Select pfID from Plattform WHERE Plattform = 'Switch')),
((Select stID  from Store WHERE Store = 'Origin'),(Select pfID from Plattform WHERE Plattform = 'PC')),
((Select stID  from Store WHERE Store = 'PlayStation Store'),(Select pfID from Plattform WHERE Plattform = 'PS5')),
((Select stID  from Store WHERE Store = 'Steam'),(Select pfID from Plattform WHERE Plattform = 'PC')),
((Select stID  from Store WHERE Store = 'Xbox Store'),(Select pfID from Plattform WHERE Plattform = 'Xbox')),
((Select stID  from Store WHERE Store = 'Xbox Store'),(Select pfID from Plattform WHERE Plattform = 'PC'));



 create Table Status
(staID int identity (1,1) Primary key,
Status NVARCHAR(30) NOT NULL UNIQUE);

insert into Status (Status)
values
('Owned'),
('Not owned'),
('Interested')

 create Table Altersangabe
(agID int identity (1,1) Primary key,
Altersangabe tinyint NOT NULL UNIQUE);

insert into Altersangabe (Altersangabe)
values
(0),
(6),
(12),
(16),
(18)

 create Table Genre
(genID int identity (1,1) Primary key,
Genre VARCHAR(25) NOT NULL UNIQUE);

INSERT INTO Genre (Genre) VALUES
('Action'),
('Adventure'),
('RPG'),
('Simulation'),
('Puzzle'),
('Strategy'),
('Shooter'),
('Platformer'),
('MMO'),
('Visual Novel'),
('Indie'),
('Fantasy')


create Table Spielerzahl
(szID int identity (1,1) Primary Key,
Spielerzahl Varchar(15) Not Null)

insert into Spielerzahl (Spielerzahl)
values ('Singleplayer'), ('Multiplayer')



create Table Price
(pID int identity (1,1) Primary Key,
Preis DECIMAL(10, 2) CHECK (Preis >= 0));
 


create Table Game
(gID int identity (1,1) Primary key,
Game NVARCHAR(30) NOT NULL UNIQUE,
Release DateTime NOT NULL UNIQUE,
Spielerzahl int NOT NULL,
ImageGame Varbinary(MAX),
ImagePath NVARCHAR(MAX) NULL,
Price int,
 FOREIGN KEY (Spielerzahl) REFERENCES Spielerzahl (szID)
	ON DELETE CASCADE,
 FOREIGN KEY (Price) REFERENCES Price (pID)
	ON DELETE CASCADE);


create Table Game_Genre
(Game int,
Genre int,
Foreign Key (Game) REFERENCES Game (gID)
	ON DELETE CASCADE,
Foreign Key (Genre) REFERENCES Genre (genID)
	ON DELETE CASCADE,
PRIMARY KEY (Game, Genre));



create Table Game_Store_Plattform
(Game int,
Store int,
Plattform int,
Status int,
Altersangabe int,
Description nvarchar (max),
Foreign Key (Game) REFERENCES Game (gID),
Foreign Key (Store, Plattform) REFERENCES Store_Plattform (Store, Plattform)
	ON DELETE CASCADE,
Foreign Key (Status) REFERENCES Status (staID)
	ON DELETE CASCADE,
Foreign Key (Altersangabe) REFERENCES Altersangabe (agID)
	ON DELETE CASCADE,
PRIMARY KEY (Game, Store,Plattform));




--Joins und Views 


select st.stID, st.Store as StoreName, pf.pfID, pf.Plattform as PlattformName
From Store st
INNER JOIN Store_Plattform spf ON st.stID = spf.Store
INNER JOIN Plattform pf ON pf.pfID = spf.Plattform


create view v_Spielinfo as
Select g.GID as GameID, g.Game AS GameName, g.Release AS ReleaseDate, gstpf.Description, 
pf.Plattform as PlattformName, st.Store as StoreName, sta.Status as StatusName, 
ag.Altersangabe as AltersangabeValue, p.Preis as Price, gen.Genre as GenreName, sz.Spielerzahl
FROM Game g
INNER JOIN Game_Store_Plattform gstpf ON g.gID = gstpf.Game
INNER JOIN Plattform pf ON pf.pfID = gstpf.Plattform
INNER JOIN Store st ON st.stID = gstpf.Store
INNER JOIN Status sta ON sta.staID = gstpf.Status
INNER JOIN Altersangabe ag ON ag.agID = gstpf.Altersangabe
INNER JOIN Price p ON g.Price = p.pID
INNER JOIN Game_Genre gg ON g.gID = gg.Game
INNER JOIN Genre gen ON gg.Genre = gen.genID
INNER JOIN Spielerzahl sz ON g.Spielerzahl = sz.szID




--zum löschen aus view 
CREATE TRIGGER trg_DeleteFromView
ON v_Spielinfo
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Game_Store_Plattform
    WHERE Game IN (SELECT GameID  FROM deleted);

    DELETE FROM Game
    WHERE gID IN (SELECT GameID  FROM deleted);
END




create VIEW v_StorePlattformInfo as 
select spf.Store as StoreID, spf.Plattform as PlattformID, st.Store as Store , pf.Plattform as Plattform
From Store_Plattform spf
INNER JOIN Store st ON spf.Store = st.stID
INNER JOIN Plattform pf ON spf.Plattform = pf.pfID 



CREATE VIEW v_Game_Store_Plattform AS
SELECT 
    gsp.Game AS GameID,
    st.stID AS StoreID,
    pf.pfID AS PlattformID,
    st.Store AS StoreName,
    pf.Plattform AS PlattformName,
    gsp.Status AS StatusID,
    gsp.Altersangabe AS AltersangabeID,
    gsp.Description
FROM Game_Store_Plattform gsp
JOIN Store st ON gsp.Store = st.stID
JOIN Plattform pf ON gsp.Plattform = pf.pfID





-- Alle Selects 
select * from Price
select * from Genre
select * from Game
select * from Game_Genre
select * from Spielerzahl
select * from Store_Plattform
select * from Store
select * from Game_Store_Plattform
select * from Altersangabe
select * from Status
select * from Plattform
select * from v_Spielinfo
select * from v_Game_Store_Plattform
select * from v_StorePlattformInfo




-- DB Management code nicht ausführen

--delete from Game where gID in (123, 124)


--delete from v_Spielinfo where GameID = 67
--delete from Game where gID IN (90)


--select GameID from v_Spielinfo where GameID = 64
