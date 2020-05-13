CREATE DATABASE Scolarship
GO
USE Scolarship
GO
CREATE TABLE Class(
	[ClassID] INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(60)
)
GO
CREATE TABLE Pupil(
	[PupilID] int PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(60),
	FK_ClassID INT FOREIGN KEY REFERENCES Class(ClassID)
)
GO
CREATE TABLE Topic(
	[TopicID] INT PRIMARY KEY IDENTITY(1, 1),
	[Name] VARCHAR(60)
)
GO
CREATE TABLE Exam(
	[ExamID] INT PRIMARY KEY IDENTITY(1, 1),
	[Note] INT NOT NULL,
	[FK_PupilID] INT FOREIGN KEY REFERENCES Pupil(PupilID),
	[FK_TopicID] INT FOREIGN KEY REFERENCES Topic(TopicID)
)
GO
INSERT INTO Topic ("Name") VALUES ('Mathématiques'), ('Français'), ('Informatique')
GO
INSERT INTO Class ("Name") VALUES ('6ème'), ('5ème'), ('4ème')
GO
INSERT INTO Pupil ("Name", "FK_ClassID") VALUES ('Hubert', 1), ('Robert', 1),
                                                ('Georges', 2), ('Bertrand', 2),
												('Gertrude', 3), ('Yvonne', 3)
GO
INSERT INTO Exam ("Note", "FK_PupilID", "FK_TopicID") VALUES (3, 1, 1), (2, 1, 2), (4, 1, 3),
															 (20, 2, 1), (20, 2, 2), (19, 2, 3),
															 (12, 3, 1), (12, 3, 2), (12, 3, 3),
															 (10, 4, 1), (9, 4, 2), (8, 4, 3),
															 (18, 5, 1), (18, 5, 2), (18, 5, 3),
															 (0, 6, 1), (2, 6, 2), (0, 6, 3)

SELECT AVG(em.Note) AS average_note, cl.Name
FROM Exam AS em
INNER JOIN Pupil ON Pupil.PupilID = em.FK_PupilID
INNER JOIN Class AS cl ON cl.ClassID = Pupil.FK_ClassID
GROUP BY cl.Name;