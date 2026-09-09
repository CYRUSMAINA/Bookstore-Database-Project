USE Bookstore_Project;
GO
-- Trigger 1: Reduce inventory when an order item is added
CREATE TRIGGER trg_ReduceInventory
ON OrderItems
AFTER INSERT
AS
BEGIN
    UPDATE i
    SET
        i.QuantityInStock = i.QuantityInStock - inserted.Quantity,
        i.LastUpdated = GETDATE()
    FROM Inventory i
    INNER JOIN inserted
        ON i.BookID = inserted.BookID;
END;
GO

-- Trigger 2: Audit order status changes
CREATE TRIGGER trg_AuditOrderStatus
ON Orders
AFTER UPDATE
AS
BEGIN
    INSERT INTO OrderAudit
        (OrderID, OldStatus, NewStatus, ChangedDate)
    SELECT
        i.OrderID,
        d.OrderStatus,
        i.OrderStatus,
        GETDATE()
    FROM inserted i
    INNER JOIN deleted d
        ON i.OrderID = d.OrderID
    WHERE i.OrderStatus <> d.OrderStatus;
END;
GO


-- Trigger 3: Restore inventory when a return is recorded
CREATE TRIGGER trg_RestoreInventory
ON Returns
AFTER INSERT
AS
BEGIN
    UPDATE i
    SET
        i.QuantityInStock = i.QuantityInStock + inserted.Quantity,
        i.LastUpdated = GETDATE()
    FROM Inventory i
    INNER JOIN OrderItems oi
        ON oi.BookID = i.BookID
    INNER JOIN inserted
        ON inserted.OrderItemID = oi.OrderItemID;
END;
GO

