CREATE DATABASE MartianDB;
GO

USE MartianDB;
GO

CREATE TABLE Continent (
id INT PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(50) NOT NULL
);

CREATE TABLE Terrien (
id INT PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(50) NOT NULL,
continent_id INT,
FOREIGN KEY (continent_id) REFERENCES Continent(id)
);

CREATE TABLE Base (
id INT PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(50) NOT NULL
);

CREATE TABLE Martian (
id INT PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(50) NOT NULL,
terrien_id INT,
base_id INT,
superior_id INT,
FOREIGN KEY (terrien_id) REFERENCES Terrien(id),
FOREIGN KEY (base_id) REFERENCES Base(id)
);
alter table Martian add constraint fk_superior 
foreign key (superior_id) references Martian(id);

INSERT INTO Base ([name]) VALUES ('Aa');
INSERT INTO Base ([name]) VALUES ('Bb');

INSERT INTO Continent([name]) VALUES ('Europe');
INSERT INTO Continent ([name]) VALUES ('Asia');
INSERT INTO Continent ([name]) VALUES ('Africa');

INSERT INTO Terrien([name], continent_id) VALUES ('Joshua', 1);
INSERT INTO Terrien([name], continent_id) VALUES ('Pak Chui', 2);
INSERT INTO Terrien([name], continent_id) VALUES ('Balumba', 3);

INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Emperor', 1, 1, 1);
INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Buba', 1, 2, 1);
INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Haba', 2, 1, 1);
INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Noba', 3, 1, 2);
INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Yaba', 1, 2, 1);
INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Kata', 3, 1, 2);
INSERT INTO Martian ([name], terrien_id, base_id, superior_id ) VALUES ('Kylian', 2, 2, 1);

SELECT mt.name AS Martin_Name, tr.name AS Terrien_Referent, ct.name AS "Referent's Continent", 
bs.name AS Martian_Base
FROM Base AS bs
INNER JOIN Martian AS mt ON mt.base_id = bs.id
INNER JOIN Terrien AS tr ON tr.id = mt.terrien_id
INNER JOIN Continent AS ct ON ct.id = tr.continent_id;


