USE Bookstore_Project;
GO

-- Function 1: Calculate the total value of an order
CREATE OR ALTER FUNCTION fn_GetOrderTotal
(
    @OrderID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total =
        SUM(Quantity * UnitPrice)
    FROM OrderItems
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO

-- Function 2: Get the current inventory quantity for a book
CREATE OR ALTER FUNCTION fn_GetInventoryQuantity
(
    @BookID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Quantity INT;

    SELECT @Quantity = QuantityInStock
    FROM Inventory
    WHERE BookID = @BookID;

    RETURN ISNULL(@Quantity, 0);
END;
GO

SELECT dbo.fn_GetInventoryQuantity(10);

-- Function 3: Get the total quantity returned for an order item
CREATE OR ALTER FUNCTION fn_GetReturnedQuantity
(
    @OrderItemID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @ReturnedQuantity INT;

    SELECT @ReturnedQuantity =
        SUM(Quantity)
    FROM Returns
    WHERE OrderItemID = @OrderItemID;

    RETURN ISNULL(@ReturnedQuantity, 0);
END;
GO

SELECT dbo.fn_GetReturnedQuantity(8);

