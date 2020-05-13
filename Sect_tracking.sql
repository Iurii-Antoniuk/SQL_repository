DROP DATABASE IF EXISTS SectTracking
GO
CREATE DATABASE SectTracking
GO

USE SectTracking

CREATE TABLE Address(address_id INT PRIMARY KEY IDENTITY(1,1),
                     street_number INT,
                     street_name VARCHAR(120) NOT NULL)
CREATE TABLE Sect(sect_id INT PRIMARY KEY IDENTITY(1,1),
                  name VARCHAR(60) NOT NULL)
CREATE TABLE Adherent(adherent_id INT PRIMARY KEY IDENTITY(1,1),
                      name VARCHAR(60))
CREATE TABLE SectAdherent(sect_adherent_id INT PRIMARY KEY IDENTITY(1,1),
                          FK_adherent_id INT NOT NULL,
                          FOREIGN KEY (FK_adherent_id) REFERENCES Adherent(adherent_id),
                          FK_sect_id INT NOT NULL,
                          FOREIGN KEY (FK_sect_id) REFERENCES Sect(sect_id))
GO

INSERT INTO Sect(name) VALUES ('Le Concombre Sacré'), ('Tomatologie'), ('Les abricots volant')
GO

DECLARE Sect_Cursor CURSOR SCROLL FOR
   SELECT sect_id FROM Sect
DECLARE @LastAdherentId INT
DECLARE @SectId INT
WHILE (SELECT COUNT(*) FROM SectAdherent) < 50
   BEGIN
      OPEN Sect_Cursor
      FETCH FIRST FROM Sect_Cursor INTO @SectId
      WHILE @@FETCH_STATUS = 0
         BEGIN
            INSERT INTO Adherent(name) VALUES(NULL)
            SET @LastAdherentId = (SELECT TOP(1) adherent_id FROM Adherent ORDER BY adherent_id DESC)
            INSERT INTO SectAdherent(FK_adherent_id, FK_sect_id) VALUES (@LastAdherentId, @SectId)
            FETCH NEXT FROM Sect_Cursor INTO @SectId
         END
      CLOSE Sect_Cursor
   END
DEALLOCATE Sect_Cursor
GO

--Nombre d'adherants par secte
DROP PROCEDURE IF EXISTS sp_adherents_perSect
GO
CREATE PROCEDURE sp_adherents_perSect
AS
  BEGIN
		SELECT Sect.name Name_of_the_Sect, COUNT(*)AS Number_of_adherents FROM Adherent
		INNER JOIN SectAdherent sa ON sa.FK_adherent_id = Adherent.adherent_id
		INNER JOIN Sect ON Sect.sect_id = sa.FK_sect_id
		GROUP BY Sect.name
  END
GO

--Chacun des adhérents à chacune des sectes
DROP PROCEDURE IF EXISTS sp_total_adhrence
GO
CREATE PROCEDURE sp_total_adhrence
AS
BEGIN
	IF (SELECT COUNT(*) FROM SectAdherent) > 0
		TRUNCATE TABLE SectAdherent
	DECLARE @adherent_id int,
			@sect_id int
	DECLARE adherent_id_Cursor CURSOR SCROLL FOR
			SELECT adherent_id FROM Adherent

	DECLARE sect_id_Cursor CURSOR SCROLL FOR
			SELECT sect_id FROM Sect
	OPEN adherent_id_Cursor
	FETCH FIRST FROM adherent_id_Cursor INTO @adherent_id
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		OPEN sect_id_Cursor
		FETCH FIRST FROM sect_id_Cursor INTO @sect_id
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			INSERT INTO SectAdherent (FK_adherent_id, FK_sect_id) VALUES (@adherent_id, @sect_id)
			FETCH NEXT FROM sect_id_Cursor INTO @sect_id
		END
		CLOSE sect_id_Cursor
		FETCH NEXT FROM adherent_id_Cursor INTO @adherent_id
	END
	CLOSE adherent_id_Cursor
	DEALLOCATE adherent_id_Cursor
	DEALLOCATE sect_id_Cursor
END
GO

--Nombre des sectes
DROP PROCEDURE IF EXISTS sp_sectNumber
GO
CREATE PROCEDURE sp_sectNumber
	@SectNumber INT OUTPUT
	AS
	BEGIN
		SELECT @SectNumber = COUNT(sect_id) FROM Sect
	END
GO

DECLARE @sect_number INT
EXECUTE sp_sectNumber @sect_number OUTPUT
PRINT @sect_number
GO
