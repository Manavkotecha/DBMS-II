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

--Part – C
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL
--during an INSERT.
--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints
--‘Record deleted successfully from PersonLog’.