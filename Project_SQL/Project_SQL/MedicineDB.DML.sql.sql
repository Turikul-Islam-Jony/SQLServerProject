Use MedicineDB
GO
--Question-4

GO
SELECT MedicineName,CustomerName,Quantity,Price,SideEffect From Orders
JOIN Customers on Customers.CustomerID=Orders.CustomerID
JOIN OrderDetails on Orders.OrderID=OrderDetails.OrderID
JOIN Medicine on Medicine.MedicineID=OrderDetails.MedicineID

--Question-5
GO
SELECT Distinct Medicine.MedicineID,MedicineName,Quantity,Price FROM Orders
JOIN OrderDetails on Orders.OrderID=OrderDetails.OrderID
JOIN Medicine on Medicine.MedicineID=OrderDetails.MedicineID
WHERE Medicine.MedicineID IN(
SELECT MedicineID FROM Medicine WHERE MedicineName='Crestor')

--Justify procedure
--EXEC spInspInsertCustomers,'KK, 'Insert'

--Justify View
--SELECT * FROM vu_MedicineInfo

--Justify Function
SELECT dbo.fnGetCustomers(2) AS CustomerName

--Justify Tabluar function
SELECT * FROM dbo.fnGetCustomersList(2)