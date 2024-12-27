
--Part – A
--1. Write a function to print "hello world".
create or alter function FN_HelloWorld()
	returns varchar(50)
as
begin

	return 'Hello World'
end;

select dbo.FN_HelloWorld(); as HELLO

--2. Write a function which returns addition of two numbers.
	create or alter function FN_Addition(
		@num1 int,
		@num2 int
		)
		returns int
	as
	begin
		declare @sum int
		set @sum = @num1 + @num2

		return @sum
	end

	select dbo.FN_Addition(37, 9) as 'sum' 
	
--3. Write a function to check whether the given number is ODD or EVEN.
	CREATE OR ALTER FUNCTION FN_ODDorEven(
    @num1 INT
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @res VARCHAR(100);

		IF (@num1 % 2 = 0)
			SET @res = 'EVEN';
		ELSE
			SET @res = 'ODD';

		RETURN @res;
	END;

SELECT dbo.FN_ODDorEven(48) AS 'result';

--4. Write a function which returns a table with details of a person whose first name starts with B.

	create or alter function FN_GetPersonsStartingWithB()

	returns table
	as
		return(
			select *
			from Person
			where FirstName like 'B%'
		)

	SELECT * FROM dbo.FN_GetPersonsStartingWithB()
	
--5. Write a function which returns a table with unique first names from the person table.
	create or alter function FN_UniqueNames()
		returns table
	as
		return(
			select distinct FirstName
			from Person
		)

	SELECT *FROM dbo.FN_UniqueNames()

--6. Write a function to print number from 1 to N. (Using while loop)

CREATE OR ALTER FUNCTION FN_Print1ToN4(@num INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @COUNT INT , @RESULT VARCHAR(100);
	SET @COUNT =1
	SET @RESULT =''

       WHILE @COUNT <= @num
       BEGIN
        SET @RESULT = @RESULT + CAST(@COUNT AS VARCHAR) + ' '
        SET @COUNT += 1; 
       END
	RETURN @RESULT;
END;

SELECT dbo.FN_Print1ToN4(12);

--7. Write a function to find the factorial of a given integer.

	CREATE OR ALTER FUNCTION FN_Factorial(
		@NUM int
	)
	    RETURNS int
	AS 
	BEGIN
		DECLARE @sum int = 1,
				@temp int = 1

		WHILE @temp <= @NUM
		BEGIN
			set @sum = @sum * @temp
			set @temp += 1
		END
		return @sum
	END

	select dbo.FN_Factorial(4) as FACTORIAL

--Part – B

--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
	CREATE OR ALTER FUNCTION  Fn_comapreTwoNumbers(
		@num1 int, @num2 int
	)
		RETURNS VARCHAR(400)
	AS 
	BEGIN
		 DECLARE @result varchar(400) = ''

		SET @result  =  CASE
							WHEN @num1 > @num2 then CAST(@num1 AS VARCHAR) + ' is greater than ' + CAST(@num2 AS VARCHAR)
							WHEN @num1 < @num2 then CAST(@num2 AS VARCHAR) + ' is greater than ' + CAST(@num1 AS VARCHAR)
							ELSE CAST(@num1 AS VARCHAR) + ' and ' + CAST(@num2 AS VARCHAR) + ' both are the same!'
						END
		RETURN @result
	END

		SELECT dbo.Fn_comapreTwoNumbers(2,4) AS RESULT
		

--9. Write a function to print the sum of even numbers between 1 to 20.
    CREATE OR ALTER FUNCTION  FN_SUM_Even()
	RETURNS int
	AS
	BEGIN
		DECLARE @Sum int = 0, @No int = 2

		WHILE @No < 20
		BEGIN
			IF(@No % 2 = 0) 
				set @Sum += @No
		set @No += 1
		END
	return @No
	END

	select dbo.FN_SUM_Even() as EvenSum


--10. Write a function that checks if a given string is a palindrome

	CREATE OR ALTER FUNCTION FN_PALINDROM( @str VARCHAR(100))
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @demo VARCHAR(100) = @str,
				@temp VARCHAR(100),
				@result VARCHAR(100);

		SET @temp = REVERSE(@str)

		IF (@temp = @demo)
			SET @result = 'The Given String is Palindrome';
		ELSE
			SET @result = 'The Given String is not Palindrome'
		RETURN @result;
	END;

SELECT dbo.FN_PALINDROM('VIRIV') AS result;

--Part – C
--11. Write a function to check whether a given number is prime or not.
	create or alter function FN_Prime(
		@Num1 int
	)
	returns varchar(100)
	as
	begin
		declare @temp int  = 2

		while @temp < SQRT(@Num1)
		begin
			if( @Num1 % @temp = 0)
				return 'The given number is not prime !!'
			
			set @temp += 1
		end

		return 'The given number is prime !!'
	end

	select dbo.FN_Prime(127)
--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
	create or alter function FN_DateDiff(
		@Date1 date, @Date2 date
	)

	returns int
	asu
	end

	select dbo.FN_DateDiff('1990-01-01', '1990-09-25') as TheDateDiff

--13. Write a function which accepts two parameters year & month in integer and returns total days each
--year.
	create or alter function FN_RemainingDays(
		@Year int , @Month int = NULL
	)
	returns int
	as
	begin
		return DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)	)	)
	end

	select dbo.FN_RemainingDays(2024, 2) as Days_In_Given_Month
--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
	create or alter function FN_department(
		@DeptID int
	)
	returns table
	as
		return(
			select *
			from Person
			where DepartmentID = @DeptID
		)

		select * from dbo.FN_department(2)
--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
	create or alter function FN_After()
	returns table
	as
		return(
			select *
			from Person
			where JoiningDate > '1991-01-01'
		)

	select * from dbo.FN_After()


