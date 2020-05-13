USE master
GO
DROP DATABASE IF EXISTS Multinational
GO
CREATE DATABASE Multinational
GO
USE Multinational
GO

CREATE TABLE [Address](address_id INT PRIMARY KEY IDENTITY(1,1),
					 street_number INT,
                     street_name VARCHAR(60),
					 zip_code INT)

CREATE TABLE Succursale(succursale_id INT PRIMARY KEY IDENTITY(1,1),  
                  FK_address_id INT UNIQUE NOT NULL, 
                  FOREIGN KEY (FK_address_id) REFERENCES [Address](address_id))

CREATE TABLE [Function] (function_id INT PRIMARY KEY IDENTITY(1,1),
                     [name] VARCHAR(30),
					 base_salary DECIMAL)


CREATE TABLE Employee(employee_id INT PRIMARY KEY IDENTITY(1,1), 
                    [name] VARCHAR(60),
					age INT,
					years_worked INT,
                    FK_superior_id INT FOREIGN KEY REFERENCES Employee(employee_id),
					FK_function_id INT FOREIGN KEY REFERENCES [Function](function_id),
					FK_succursale_id INT FOREIGN KEY REFERENCES Succursale(succursale_id))
GO

INSERT INTO [Function] ([name], base_salary) VALUES ('cockSucker', 4000.00), ('assEater', 4500.00),
													('publicUrinator', 1300.00), ('midnightDwarfRapist', 14500.00),
													('jewExterminator', 13000.00)

INSERT INTO [Address] (street_number, street_name, zip_code) 
VALUES (23, 'Elm street', 76800), (1, 'Baker street', 12200), (23, 'rue du Maréchal Pétain', 67200),
		(23, 'rue Philippe Katerine', 75008), (23, 'Grande rue du Trou de Cul', 67100)

INSERT INTO Succursale (FK_address_id) VALUES (2), (3), (1), (5), (4)
GO
												

Declare @number_employee INT = 0
Declare @name_suffix INT = 1
Declare @FK_succursale_id INT = 1
Declare @superior_id INT = 1

WHILE(@number_employee <= 50)
BEGIN
   Declare @name VARCHAR(20) = 'Employe ' + CONVERT(VARCHAR, @name_suffix)
   INSERT INTO Employee ([name], age, years_worked, FK_superior_id, FK_function_id, FK_succursale_id) 
   VALUES (@name, FLOOR(RAND()*(67-17+1))+17, FLOOR(RAND()*(47-0+1))+0, @superior_id, FLOOR(RAND()*(5-1+1))+1, FLOOR(RAND()*(5-1+1))+1)
   SET @name_suffix = @name_suffix + 1
   SELECT @number_employee = (SELECT COUNT(employee_id) FROM Employee WHERE FK_succursale_id = @FK_succursale_id)

   IF (@number_employee = 50 AND @FK_succursale_id < 5)
   BEGIN
		SET @FK_succursale_id = @FK_succursale_id + 1
		SET @superior_id = FLOOR(RAND()*(10-1+1))+1
	END
END
GO

Select * from Employee