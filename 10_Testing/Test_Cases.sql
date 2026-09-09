USE Bookstore_Project;
GO

-- Test 1: usp_CreateOrder - invalid UserID
-- Expected result: Error message "User does not exist."

EXEC usp_CreateOrder
    @UserID = 9999,
    @OrderStatus = 'Pending';
GO

-- Test 2: usp_ProcessReturn - invalid return quantity
-- Expected result: Error message
-- "Return quantity cannot exceed purchased quantity."

EXEC usp_ProcessReturn
    @OrderItemID = 8,
    @ReturnQuantity = 3,
    @ReturnReason = 'Testing invalid return';
GO


-- Test 3: usp_UpdateOrderStatus - invalid OrderID
-- Expected result: Error message "Order does not exist."

EXEC usp_UpdateOrderStatus
    @OrderID = 9999,
    @NewStatus = 'Shipped';
GO

-- Test 4: trg_AuditOrderStatus
-- Expected result: A new audit record showing the old and new status.

EXEC usp_UpdateOrderStatus
    @OrderID = 4,
    @NewStatus = 'Delivered';
GO

SELECT
    AuditID,
    OrderID,
    OldStatus,
    NewStatus,
    ChangedDate
FROM OrderAudit
WHERE OrderID = 4
ORDER BY ChangedDate DESC;
GO

-- Test 5: trg_ReduceInventory
-- Expected result: Inventory decreases by the ordered quantity.

SELECT
    BookID,
    QuantityInStock
FROM Inventory
WHERE BookID = 10;
GO

INSERT INTO OrderItems
    (OrderID, BookID, Quantity, UnitPrice)
VALUES
    (4, 10, 2, 24.99);
GO

SELECT
    BookID,
    QuantityInStock
FROM Inventory
WHERE BookID = 10;
GO

-- Test 6: trg_RestoreInventory
-- Expected result: Inventory increases by the returned quantity.

SELECT
    BookID,
    QuantityInStock
FROM Inventory
WHERE BookID = 10;
GO

-- Find the order item created in Test 5
SELECT
    OrderItemID,
    OrderID,
    BookID,
    Quantity
FROM OrderItems
WHERE OrderID = 4
  AND BookID = 10
ORDER BY OrderItemID DESC;
GO

DECLARE @TestOrderItemID INT;

SELECT TOP 1
    @TestOrderItemID = OrderItemID
FROM OrderItems
WHERE OrderID = 4
  AND BookID = 10
ORDER BY OrderItemID DESC;

EXEC usp_ProcessReturn
    @OrderItemID = @TestOrderItemID,
    @ReturnQuantity = 1,
    @ReturnReason = 'Customer changed mind';
GO

SELECT
    BookID,
    QuantityInStock
FROM Inventory
WHERE BookID = 10;
GO

-- Test 7: Orders foreign key constraint
-- Expected result: Insert is rejected because UserID 9999 does not exist.

INSERT INTO Orders
    (UserID, OrderDate, OrderStatus)
VALUES
    (9999, GETDATE(), 'Pending');
GO

-- Test 8: OrderItems foreign key constraint
-- Expected result: Insert is rejected because BookID 9999 does not exist.

INSERT INTO OrderItems
    (OrderID, BookID, Quantity, UnitPrice)
VALUES
    (4, 9999, 1, 20.00);
GO

-- Test 9: OrderItems quantity CHECK constraint
-- Expected result: Insert is rejected because Quantity must be greater than zero.

INSERT INTO OrderItems
    (OrderID, BookID, Quantity, UnitPrice)
VALUES
    (4, 10, 0, 24.99);
GO