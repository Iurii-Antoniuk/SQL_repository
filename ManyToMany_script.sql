CREATE DATABASE ManyToMany
GO

USE ManyToMany
GO

CREATE TABLE Students 
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	studentName NVARCHAR(50)
)
GO

CREATE TABLE Courses 
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	courseName NVARCHAR(50)
)
GO

CREATE TABLE StudentCourses
(
	StudentId int not null foreign key references Students(Id),
	CourseId int not null foreign key references Courses(Id),
)
GO

Alter Table StudentCourses
Add Constraint PK_StudentCourses
Primary Key Clustered (StudentId, CourseId)


Create Procedure InsertInto_StudentCourses
@StudentName nvarchar(50),
@CourseName nvarchar(50)

as
Begin
	Declare @StudentId int
	Declare @CourseId int

	Select @StudentId = Id From Students Where studentName = @StudentName
	if (@StudentId is null)
	Begin
		Insert Into Students Values (@StudentName)
		Select @StudentId = SCOPE_IDENTITY() 
	End

	Select @CourseId = Id From Courses Where courseName = @CourseName
	if (@CourseId is null)
	Begin
		Insert Into Courses Values (@CourseName)
		Select @CourseId = SCOPE_IDENTITY() 
	End

	Insert into StudentCourses Values (@StudentId, @CourseId)
End