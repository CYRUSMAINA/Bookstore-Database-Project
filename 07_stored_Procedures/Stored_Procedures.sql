USE Bookstore_Project;
GO

-- Procedure 1: Create a new order
CREATE OR ALTER PROCEDURE usp_CreateOrder
    @UserID INT,
    @OrderStatus VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS (
            SELECT 1
            FROM Users
            WHERE UserID = @UserID
        )
        BEGIN
            THROW 50001, 'User does not exist.', 1;
        END;

        DECLARE @NewOrderID INT;

        INSERT INTO Orders
            (UserID, OrderNumber, OrderDate, OrderStatus)
        VALUES
            (@UserID, NEXT VALUE FOR OrderNumberSequence, GETDATE(), @OrderStatus);

        SET @NewOrderID = SCOPE_IDENTITY();

        SELECT
            OrderID,
            OrderNumber,
            UserID,
            OrderDate,
            OrderStatus
        FROM Orders
        WHERE OrderID = @NewOrderID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Procedure 2: Update an order's status
CREATE OR ALTER PROCEDURE usp_UpdateOrderStatus
    @OrderID INT,
    @NewStatus VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS (
            SELECT 1
            FROM Orders
            WHERE OrderID = @OrderID
        )
        BEGIN
            THROW 50002, 'Order does not exist.', 1;
        END;

        UPDATE Orders
        SET OrderStatus = @NewStatus
        WHERE OrderID = @OrderID;

        SELECT
            OrderID,
            UserID,
            OrderDate,
            OrderStatus
        FROM Orders
        WHERE OrderID = @OrderID;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Procedure 3: Process a book return
CREATE OR ALTER PROCEDURE usp_ProcessReturn
    @OrderItemID INT,
    @ReturnQuantity INT,
    @ReturnReason VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        DECLARE @PurchasedQuantity INT;
        DECLARE @OrderID INT;
        DECLARE @OrderStatus VARCHAR(50);

        -- Check that the order item exists
        IF NOT EXISTS (
            SELECT 1
            FROM OrderItems
            WHERE OrderItemID = @OrderItemID
        )
        BEGIN
            THROW 50003, 'Order item does not exist.', 1;
        END;

        -- Get purchased quantity and order information
        SELECT
            @PurchasedQuantity = oi.Quantity,
            @OrderID = oi.OrderID
        FROM OrderItems oi
        WHERE oi.OrderItemID = @OrderItemID;

        -- Get the order status
        SELECT
            @OrderStatus = OrderStatus
        FROM Orders
        WHERE OrderID = @OrderID;

        -- Only shipped or delivered orders can be returned
        IF @OrderStatus NOT IN ('Shipped', 'Delivered')
        BEGIN
            THROW 50004, 'Only shipped or delivered orders can be returned.', 1;
        END;

        -- Validate return quantity
        IF @ReturnQuantity <= 0
        BEGIN
            THROW 50005, 'Return quantity must be greater than zero.', 1;
        END;

        IF @ReturnQuantity > @PurchasedQuantity
        BEGIN
            THROW 50006, 'Return quantity cannot exceed purchased quantity.', 1;
        END;

        -- Create the return
        INSERT INTO Returns
            (OrderItemID, ReturnDate, Quantity, ReturnReason, ReturnStatus)
        VALUES
            (
                @OrderItemID,
                CAST(GETDATE() AS DATE),
                @ReturnQuantity,
                @ReturnReason,
                'Approved'
            );

        SELECT
            'Return processed successfully.' AS Message,
            @OrderItemID AS OrderItemID,
            @ReturnQuantity AS ReturnedQuantity;

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

-- Procedure 4: Generate weekly order report using a cursor
CREATE OR ALTER PROCEDURE usp_GenerateWeeklyOrderReport
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        TRUNCATE TABLE WeeklyOrderReport;

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

        SELECT
            ReportID,
            OrderID,
            CustomerName,
            OrderStatus,
            OrderTotal,
            ReportDate
        FROM WeeklyOrderReport
        ORDER BY OrderID;

    END TRY

    BEGIN CATCH

        IF CURSOR_STATUS('local', 'OrderCursor') >= 0
        BEGIN
            CLOSE OrderCursor;
        END;

        IF CURSOR_STATUS('local', 'OrderCursor') >= -1
        BEGIN
            DEALLOCATE OrderCursor;
        END;

        THROW;

    END CATCH;
END;
GO