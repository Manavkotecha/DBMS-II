-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);

-- Creating PersonLog Table
CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL,
);

DROP TABLE PersonLog

--Part – A

--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display
--a message “Record is Affected.”

CREATE TRIGGER TR_INSERT_UPDATE_DELETE
ON PersonInfo 
AFTER INSERT,UPDATE,DELETE
AS
BEGIN 
     PRINT('RECORD IS AFFECTED')
END 


--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,
--log all operations performed on the person table into PersonLog.

CREATE TRIGGER TR_INSERT_LOG
ON PersonInfo 
AFTER INSERT
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(250)

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     INSERT INTO PersonLog VALUES(@PersonID,@PersonName,'INSERT',GETDATE())
END 

CREATE TRIGGER TR_UPDATE_LOG
ON PersonInfo 
AFTER UPDATE
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(250)

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     INSERT INTO PersonLog VALUES(@PersonID,@PersonName,'UPDATE',GETDATE())
END 

CREATE TRIGGER TR_DELETE_LOG
ON PersonInfo 
AFTER DELETE
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(250)

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     INSERT INTO PersonLog VALUES(@PersonID,@PersonName,'DELETE',GETDATE())
END 

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo
--table. For that, log all operations performed on the person table into PersonLog.

CREATE TRIGGER TR_INSERT_INSTEAD_INSERT
ON PersonInfo 
INSTEAD OF INSERT
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(250)

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     INSERT INTO PersonLog VALUES(@PersonID,@PersonName,'TRIED INSERT',GETDATE())
END 

CREATE TRIGGER TR_INSERT_INSTEAD_UPDATE
ON PersonInfo 
INSTEAD OF UPDATE
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(250)

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     INSERT INTO PersonLog VALUES(@PersonID,@PersonName,'TRIED UPDATE',GETDATE())
END

CREATE TRIGGER TR_INSERT_INSTEAD_DELETE
ON PersonInfo 
INSTEAD OF DELETE
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(250)

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     INSERT INTO PersonLog VALUES(@PersonID,@PersonName,'TRIED DELETE',GETDATE())
END


--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into
--uppercase whenever the record is inserted.

CREATE TRIGGER TR_INSERT_UPPER
ON PersonInfo 
AFTER INSERT
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(100) 

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
     UPDATE PersonInfo
	 SET PersonName = UPPER(@PersonName)
	 WHERE PERSONID = @PersonID
END

INSERT INTO PersonInfo VALUES(10,'dfsdf',20000,'2005-12-12','FDSF',45,'2005-10-10')
SELECT *FROM PersonInfo

--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.

CREATE TRIGGER TR_INSERT_DUPLICATE_NAME
ON PersonInfo 
INSTEAD OF INSERT
AS
BEGIN 
     INSERT INTO PersonInfo(PersonID,PersonName,Salary,JoiningDate ,City,Age,BirthDate)
	 SELECT PersonID,PersonName,Salary,JoiningDate ,City,Age,BirthDate FROM inserted 
	 WHERE PersonName NOT IN(SELECT PersonName FROM PersonInfo)

	 PRINT('DUPLICATE NAME IS NOT ALLOWED')
END

--6. Create trigger that prevent Age below 18 years.

CREATE TRIGGER TR_INSERT_AGE
ON PersonInfo 
INSTEAD OF INSERT
AS
BEGIN 
      INSERT INTO PersonInfo(PersonID,PersonName,Salary,JoiningDate ,City,Age,BirthDate)
	  SELECT PersonID,PersonName,Salary,JoiningDate ,City,Age,BirthDate FROM inserted
	  WHERE AGE >= 18

	  PRINT('LESS THAN 18 IS NOT ALLOWED')
END


--Part – B

--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update
--that age in Person table.

CREATE TRIGGER TR_INSERT_AGE
ON PersonInfo 
AFTER INSERT
AS
BEGIN 
     DECLARE  @PersonID INT,@PersonName VARCHAR(100) , @AGE INT

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @PersonName = PersonName FROM inserted
	 SELECT @AGE = DATEDIFF(YEAR,BirthDate,GETDATE()) FROM inserted
     UPDATE PersonInfo
	 SET Age = @AGE
	 WHERE PERSONID = @PersonID
END

--8. Create a Trigger to Limit Salary Decrease by a 10%.

CREATE TRIGGER TR_INSERT_LIMIT_SALLARY
ON PersonInfo 
AFTER Update
AS
BEGIN 
     DECLARE  @PersonID INT, @OLD_SALARY INT , @NEW_SALARY INT

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @NEW_SALARY = SALARY FROM inserted
	 SELECT @OLD_SALARY = SALARY FROM deleted

	 IF @NEW_SALARY < @OLD_SALARY *0.9
	 BEGIN 

		UPDATE PersonInfo
		SET SALARY = @OLD_SALARY
		WHERE PERSONID = @PersonID

	END
END

--Part – C
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL
--during an INSERT.

CREATE TRIGGER TR_UPDATE_JOINING_DATE
ON PersonInfo 
AFTER INSERT 
AS
BEGIN 
     DECLARE  @PersonID INT,@DATE_JOIN DATETIME

	 SELECT @PersonID = PERSONID FROM inserted
	 SELECT @DATE_JOIN = JoiningDate FROM inserted

	IF @DATE_JOIN IS NULL
	BEGIN 
		UPDATE PersonInfo
		SET JoiningDate = @DATE_JOIN
		WHERE PersonID = @PersonID
		
	END
END


--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints
--‘Record deleted successfully from PersonLog’.

CREATE TRIGGER TR_DELETE_PERSONLOG
ON PersonLog
AFTER DELETE
AS 
BEGIN
    PRINT 'RECORD DELETED SUCCESSFULLY'
END



--------------------------------------------EXTRA LAB-------------------------------------


CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);

--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table 
--to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"

CREATE TRIGGER TR_INSERT_2
ON EMPLOYEEDETAILS 
AFTER INSERT
AS
BEGIN 
     PRINT('Employee record inserted')
END

CREATE TRIGGER TR_UPDATE_2
ON EMPLOYEEDETAILS 
AFTER UPDATE
AS
BEGIN 
     PRINT('Employee record UPDATED')
END

CREATE TRIGGER TR_DELETE_2
ON EMPLOYEEDETAILS 
AFTER DELETE
AS
BEGIN 
     PRINT('Employee record DELETED')
END



--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,
--log all operations performed on the person table into PersonLog.

CREATE TRIGGER TR_INSERT_LOG_2
ON EMPLOYEEDETAILS 
AFTER INSERT
AS
BEGIN 
     DECLARE  @EMPID INT,@EMPName VARCHAR(250)

	 SELECT @EMPID = EmployeeID FROM inserted
	 SELECT @EMPName = EmployeeNAME FROM inserted
     INSERT INTO EmployeeLogs VALUES(@EMPID,@EMPName,'INSERT',GETDATE())
END 

CREATE TRIGGER TR_UPDATE_LOG_2
ON EMPLOYEEDETAILS 
AFTER UPDATE
AS
BEGIN 
     DECLARE  @EMPID INT,@EMPName VARCHAR(250)

	 SELECT @EMPID = EmployeeID FROM inserted
	 SELECT @EMPName = EmployeeNAME FROM inserted
     INSERT INTO EmployeeLogs VALUES(@EMPID,@EMPName,'UPDATE',GETDATE())
END 

CREATE TRIGGER TR_DELETE_LOG_2
ON EMPLOYEEDETAILS 
AFTER DELETE
AS
BEGIN 
    DECLARE  @EMPID INT,@EMPName VARCHAR(250)

	 SELECT @EMPID = EmployeeID FROM inserted
	 SELECT @EMPName = EmployeeNAME FROM inserted
     INSERT INTO EmployeeLogs VALUES(@EMPID,@EMPName,'DELETE',GETDATE())
END 

--3)	Create a trigger that fires AFTER INSERT to automatically calculate 
--the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.

CREATE TRIGGER TR_INSERT_LIMIT_SALLARY_2
ON EMPLOYEEDETAILS 
AFTER Update
AS
BEGIN 
     DECLARE  @EmployeeID INT, @NEW_SALARY INT

	 SELECT @EmployeeID = EmployeeID FROM inserted
	 SELECT @NEW_SALARY = SALARY FROM inserted

	UPDATE EMPLOYEEDETAILS
	SET SALARY = @NEW_SALARY + @NEW_SALARY * 0.1
	WHERE EmployeeID = @EmployeeID
END

--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.


CREATE TRIGGER TR_UPDATE_JOINING_DATE_2
ON EMPLOYEEDETAILS 
AFTER INSERT 
AS
BEGIN 
     DECLARE  @EmployeeID INT,@DATE_JOIN DATETIME

	 SELECT @EmployeeID = EmployeeID FROM inserted
	 SELECT @DATE_JOIN = JoiningDate FROM inserted

	IF @DATE_JOIN IS NULL
	BEGIN 
		UPDATE EMPLOYEEDETAILS
		SET JoiningDate = @DATE_JOIN
		WHERE EmployeeID = @EmployeeID
		
	END
END


--5)	Create a trigger that ensure that ContactNo is valid during insert (Like ContactNo length is 10)

CREATE TRIGGER TR_INSERT_LIMIT_SALLARY_3
ON EMPLOYEEDETAILS 
AFTER Update
AS
BEGIN 
       DECLARE  @EmployeeID INT,@CON INT

	 SELECT @EmployeeID = EmployeeID FROM inserted
	 SELECT @CON = ContactNo FROM inserted

	 IF LEN(@CON) != 10
	 BEGIN 

		UPDATE EMPLOYEEDETAILS
		SET ContactNo = @CON
		WHERE EmployeeID = @EmployeeID

	END
END

------------------------INSTEAD OF-----------------------------

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);


CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);


--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table.
--      For that, log all operations performed on the Movies table into MoviesLog.

CREATE TRIGGER tr_MoviesLog
ON Movies
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @MovieID INT, @MovieTitle VARCHAR(255), @ActionPerformed VARCHAR(100);

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SELECT @MovieID = MovieID, @MovieTitle = MovieTitle FROM inserted;
        SET @ActionPerformed = 'INSERT';
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        VALUES (@MovieID, @MovieTitle, @ActionPerformed, GETDATE());
    END

    
    IF EXISTS (SELECT * FROM updated)
    BEGIN
        SELECT @MovieID = MovieID, @MovieTitle = MovieTitle FROM updated;
        SET @ActionPerformed = 'UPDATE';
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        VALUES (@MovieID, @MovieTitle, @ActionPerformed, GETDATE());
    END

  
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT @MovieID = MovieID, @MovieTitle = MovieTitle FROM deleted;
        SET @ActionPerformed = 'DELETE';
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        VALUES (@MovieID, @MovieTitle, @ActionPerformed, GETDATE());
    END
END;


CREATE TRIGGER tr_RatingCheck
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Rating <= 5.5)
    BEGIN
        
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'RATING_TOO_LOW', GETDATE() FROM inserted;
    END
    ELSE
    BEGIN
        INSERT INTO Movies (MovieID, MovieTitle, Rating)
        SELECT MovieID, MovieTitle, Rating FROM inserted;
    END
END;


--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.

CREATE TRIGGER trg_PreventDuplicateTitle
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @MovieTitle VARCHAR(255);
    SELECT @MovieTitle = MovieTitle FROM inserted;

    IF EXISTS (SELECT * FROM Movies WHERE MovieTitle = @MovieTitle)
    BEGIN
        
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'DUPLICATE_TITLE', GETDATE() FROM inserted;
    END
    ELSE
    BEGIN
        INSERT INTO Movies (MovieID, MovieTitle)
        SELECT MovieID, MovieTitle FROM inserted;
    END
END;



--4.	Create trigger that prevents to insert pre-release movies.

CREATE TRIGGER trg_PreventPreReleaseMovies
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ReleaseYear INT;
    SELECT @ReleaseYear = ReleaseYear FROM inserted;

    IF @ReleaseYear < YEAR(GETDATE())
    BEGIN
        
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'PRE_RELEASE', GETDATE() FROM inserted;
    END
    ELSE
    BEGIN
        INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear)
        SELECT MovieID, MovieTitle, ReleaseYear FROM inserted;
    END
END;



--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours)
--      to prevent unrealistic entries.

CREATE TRIGGER trg_PreventDurationUpdate
ON Movies
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @NewDuration INT;
    SELECT @NewDuration = Duration FROM updated;

    IF @NewDuration > 120
    BEGIN
       
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'DURATION_TOO_LONG', GETDATE() FROM updated;
    END
    ELSE
    BEGIN
        UPDATE Movies SET Duration = @NewDuration WHERE MovieID IN (SELECT MovieID FROM updated);
    END
END;

