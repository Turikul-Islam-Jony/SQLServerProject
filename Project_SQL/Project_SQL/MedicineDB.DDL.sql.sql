--Question-1
USE master
GO
IF DB_ID('MedicineDB') IS NOT NULL
DROP DATABASE MedicineDB
GO
CREATE DATABASE MedicineDB
ON(
Name='MedicineDB_Data_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MedicineDB_Data_1.mdf',
Size=25 MB,
MaxSize=100 MB,
FileGrowth=5%
)
LOG ON(
Name='MedicineDB_Log_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MedicineDB_Log_1.ldf',
Size=2 MB,
MaxSize=25 MB,
FileGrowth=1%
)

GO
CREATE TABLE Medicine(
MedicineID int PRIMARY KEY NOT NULL,
MedicineName varchar(30),
Price money,
SideEffect varchar(20)
)
GO
CREATE TABLE Customers(
CustomerID int PRIMARY KEY nonclustered NOT NULL,
CustomerName varchar(10)
)

GO
CREATE TABLE Orders(
OrderID int PRIMARY KEY NOT NULL,
CustomerID int references Customers(CustomerID),
OrderDate DateTime
)

GO
CREATE TABLE OrderDetails(
OrderID int references Orders(OrderID),
MedicineID int references Medicine(MedicineID),
Quantity int
)
GO
--Question-7
CREATE Clustered Index ix_Customers_CustomerName
ON Customers(CustomerName)
--Justify
EXEC sp_helpindex Customers
--Question-2
GO
INSERT INTO Medicine(MedicineID,MedicineName,Price,SideEffect)
VALUES
(1,'Synthorid',15,'Diarrhea'),
(2,'Crestor',5,'Skin rash'),
(3,'Lantus Solostar',30,'Skin rash'),
(4,'Januvia',12,'No side effect'),
(5,'Ventolin HFA',40,'Headache'),
(6,'Advair Diskus',32,'Headache'),
(7,'Nexium',20,'Dry mouth'),
(8,'Spiriva Handihaler',35,'Headache')


GO
INSERT INTO Customers(CustomerID,CustomerName)
VALUES
(1,'AA'),(2,'BB'),(3,'CC'),(4,'DD'),(5,'FF'),(6,'RR')
GO
INSERT INTO Orders(OrderID,CustomerID,OrderDate)
VALUES
(1,1,'2019-01-01'),
(2,2,'2019-03-20'),
(3,3,'2019-03-20'),
(4,3,'2019-12-31'),
(5,5,'2019-12-31'),
(6,6,'2020-01-05'),
(7,4,'2020-01-15'),
(8,6,'2020-01-15'),
(9,6,'2020-01-05'),
(10,3,'2019-12-31'),
(11,5,'2019-12-31')

GO
INSERT INTO OrderDetails(OrderID,MedicineID,Quantity)
VALUES 
(1,1,5),(2,2,10),(2,3,10),(3,1,2),(3,4,2),(4,5,5),(4,6,5),(5,7,7),(5,4,7),(6,8,9),(7,7,9),(8,2,10),(8,4,10)

--Question-3
GO
CREATE PROC spInsertCustomers
@CustomerID int,
@CustomerName varchar(10),
@sType varchar(10)
AS 
BEGIN
IF @sType='Insert'
BEGIN TRY
INSERT INTO Customers
VALUES(@CustomerID,@CustomerName)
END TRY
BEGIN CATCH
SELECT
ERROR_Number() AS ErrorNumber,
ERROR_Message() AS ErrorMessage,
ERROR_State() AS ErrorState,
ERROR_Severity() AS Severity
END CATCH
END

GO
CREATE PROC spCustomersCount
@CustomersCount int OUTPUT
AS
BEGIN
SELECT @CustomersCount=COUNT(*) FROM Customers
END
--Justify
--DECLARE @Count int
--EXEC spCustomersCount @Count OUTPUT
--PRINT @Count

GO
--Question-6
CREATE VIEW vu_MedicineInfo
AS
SELECT MedicineName,CustomerName,Quantity,Price,SideEffect From Orders
JOIN Customers on Customers.CustomerID=Orders.CustomerID
JOIN OrderDetails on Orders.OrderID=OrderDetails.OrderID
JOIN Medicine on Medicine.MedicineID=OrderDetails.MedicineID

GO
--Question-8
CREATE FUNCTION fnGetCustomers(@CustomerID int)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @name varchar;
SELECT @name=CustomerName FROM Customers WHERE @CustomerID=@CustomerID
RETURN @name
END
GO
CREATE Function fnGetCustomersList(@CustomerID int)
RETURNS TABLE
RETURN
SELECT * FROM Customers WHERE @CustomerID>@CustomerID

SELECT CAST('1/7/2020 00:10:00' AS date)
SELECT CONVERT(time,'1/7/2020 10:00:00',101)
--Questions-9
GO
CREATE TRIGGER trInsertCustomers
ON Customers
AFTER Insert
AS
BEGIN
SELECT * FROM Inserted
END
--Justify
INSERT INTO Customers
VALUES(10,'KK')
GO
CREATE TRIGGER trCustomersDelete
ON Customers
FOR DELETE
AS
BEGIN
PRINT 'You have no permission to delete data from this table'
ROLLBACK TRAN
END
--Justify

DELETE FROM Customers WHERE CustomerID=10
