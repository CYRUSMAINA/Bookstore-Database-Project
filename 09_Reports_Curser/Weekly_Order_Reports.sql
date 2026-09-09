USE Bookstore_Project;
GO
-- Table for storing weekly order report results
CREATE TABLE WeeklyOrderReport (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    CustomerName VARCHAR(100),
    OrderStatus VARCHAR(50),
    OrderTotal DECIMAL(10,2),
    ReportDate DATE DEFAULT GETDATE()
);
GO

-- Cursor: Populate the weekly order report
DECLARE @OrderID INT;
DECLARE @CustomerName VARCHAR(100);
DECLARE @OrderStatus VARCHAR(50);
DECLARE @OrderTotal DECIMAL(10,2);

DECLARE OrderCursor CURSOR FOR
SELECT
    o.OrderID,
    u.FirstName + ' ' + u.LastName AS CustomerName,
    o.OrderStatus
FROM Orders o
INNER JOIN Users u
    ON o.UserID = u.UserID;

OPEN OrderCursor;

FETCH NEXT FROM OrderCursor
INTO @OrderID, @CustomerName, @OrderStatus;

WHILE @@FETCH_STATUS = 0
BEGIN

    SET @OrderTotal = dbo.fn_GetOrderTotal(@OrderID);

    INSERT INTO WeeklyOrderReport
        (OrderID, CustomerName, OrderStatus, OrderTotal)
    VALUES
        (@OrderID, @CustomerName, @OrderStatus, @OrderTotal);

    FETCH NEXT FROM OrderCursor
    INTO @OrderID, @CustomerName, @OrderStatus;
END;

CLOSE OrderCursor;
DEALLOCATE OrderCursor;
GO

