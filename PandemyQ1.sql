IF DB_ID('PandemyAlert') IS NOT NULL
 DROP DATABASE PandemyAlert
GO
CREATE DATABASE PandemyAlert
GO

USE PandemyAlert

CREATE TABLE Country(country_id INT PRIMARY KEY IDENTITY(1,1),
                     name VARCHAR(60) NOT NULL)
CREATE TABLE City(city_id INT PRIMARY KEY IDENTITY(1,1), 
                  name VARCHAR(60) NOT NULL, 
                  FK_country_id INT NOT NULL, 
                  FOREIGN KEY (FK_country_id) REFERENCES Country(country_id))
CREATE TABLE Person(person_id INT PRIMARY KEY IDENTITY(1,1), 
                    name VARCHAR(60),
                    is_infected BIT NOT NULL,
                    FK_city_id INT NOT NULL,
                    FOREIGN KEY (FK_city_id) REFERENCES City(city_id))
CREATE TABLE Pharmaceutical(pharmaceutical_id INT PRIMARY KEY IDENTITY(1,1), 
                            disease VARCHAR(60) NOT NULL, 
                            count INT NOT NULL)

INSERT INTO Country (name) VALUES ('France'),
                                  ('Allemagne'),
                                  ('Italie'),
                                  ('Etats-Unis'),
                                  ('Chine'),
                                  ('Russie')
INSERT INTO City(name, FK_Country_id) VALUES ('Paris', 1),('Strasbourg',1),
                                             ('Berlin', 2),('Cologne', 2),
                                             ('Rome', 3),('Florence', 3),
                                             ('Washington', 4),('New York', 4),
                                             ('Pékin', 5),('Shangaï', 5),
                                             ('St-Pétersbourg', 6),('Moscou', 6)
INSERT INTO Pharmaceutical(disease, count) VALUES ('Triméthylaminurie', 50)
GO

Declare @number_person INT = 0
Declare @name_suffix INT = 1
Declare @fk_cityid INT = 1

WHILE(@number_person <= 10)
BEGIN
   Declare @name VARCHAR(20) = 'Individual' + CONVERT(VARCHAR, @name_suffix)
   INSERT INTO Person ([name], is_infected, FK_city_id) VALUES (@name, FLOOR(RAND()*(1-0+1))+0, @fk_cityid)
   SET @name_suffix = @name_suffix + 1
   SELECT @number_person = (SELECT COUNT(person_id) FROM Person WHERE FK_city_id = @fk_cityid)

   IF (@number_person = 10 AND @fk_cityid < 12)
		SET @fk_cityid = @fk_cityid + 1              
END
GO

Declare @number_countries INT = (SELECT COUNT(country_id) FROM Country)
Declare @number_cases INT = (SELECT COUNT(person_id) FROM Person WHERE is_infected = 1) 
Declare @avg_country INT = @number_cases/@number_countries
Declare @country_id INT

DECLARE @CountryCursor as CURSOR;
SET @CountryCursor = CURSOR FOR
SELECT country_id FROM Country;
 
OPEN @CountryCursor;
FETCH NEXT FROM @CountryCursor INTO @country_id;

WHILE @@FETCH_STATUS = 0
BEGIN
   declare @cases_perCountry int
   set @cases_perCountry = (SELECT COUNT(*) AS Number_Infected FROM Person
							INNER JOIN City ON City.city_id = Person.FK_city_id
							INNER JOIN Country ON Country.country_id = City.FK_country_id
							WHERE Person.is_infected = 1 AND Country.country_id = @country_id
							GROUP BY Country.name)
	if (@cases_perCountry >= @avg_country)
	BEGIN
		SELECT City.[name] AS City, COUNT(*) AS Number_Infected
		FROM Person
		INNER JOIN City ON City.city_id = Person.FK_city_id
		INNER JOIN Country ON Country.country_id = City.FK_country_id
		WHERE Person.is_infected = 1 AND Country.country_id = @country_id
		GROUP BY City.[name]
	END
	FETCH NEXT FROM @CountryCursor INTO @country_id
END
CLOSE @CountryCursor;
DEALLOCATE @CountryCursor;
GO

