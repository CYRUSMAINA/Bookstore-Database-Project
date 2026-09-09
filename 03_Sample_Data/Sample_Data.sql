USE Bookstore_Project;
GO
-- Users
INSERT INTO Users (FirstName, LastName, Email, Phone)
VALUES
('John', 'Smith', 'john.smith@email.com', '416-555-1001'),
('Sarah', 'Johnson', 'sarah.johnson@email.com', '416-555-1002'),
('Michael', 'Brown', 'michael.brown@email.com', '416-555-1003'),
('Emily', 'Wilson', 'emily.wilson@email.com', '416-555-1004'),
('David', 'Taylor', 'david.taylor@email.com', '416-555-1005');
GO

-- Authors
INSERT INTO Authors (AuthorName)
VALUES
('J.K. Rowling'),
('George Orwell'),
('Stephen King'),
('Agatha Christie'),
('Yuval Noah Harari');
GO

-- Categories
INSERT INTO Categories (CategoryName)
VALUES
('Fiction'),
('Technology'),
('Business'),
('Health'),
('History');
GO

-- Books
INSERT INTO Books
    (Title, ISBN, AuthorID, CategoryID, Price, PublishedDate)
VALUES
('Harry Potter', '9780747532699', 1, 1, 19.99, '1997-06-26'),
('1984', '9780451524935', 2, 1, 14.99, '1949-06-08'),
('The Shining', '9780307743657', 3, 1, 18.99, '1977-01-28'),
('Murder on the Orient Express', '9780062693662', 4, 1, 16.99, '1934-01-01'),
('Sapiens', '9780062316097', 5, 5, 22.99, '2011-01-01'),
('The Art of SQL', '9781590598155', 2, 2, 29.99, '2005-01-01'),
('The Digital Transformation', '9781119672869', 5, 2, 34.99, '2020-01-01'),
('Business Analytics', '9781119548217', 5, 3, 39.99, '2018-01-01'),
('Health Informatics', '9780323831290', 3, 4, 49.99, '2022-01-01'),
('The Business Book', '9781409382995', 4, 3, 24.99, '2014-01-01');
GO

-- Inventory
INSERT INTO Inventory
    (BookID, QuantityInStock, ReorderLevel)
VALUES
(1, 25, 5),
(2, 30, 5),
(3, 20, 5),
(4, 15, 4),
(5, 25, 5),
(6, 18, 4),
(7, 12, 3),
(8, 20, 5),
(9, 10, 3),
(10, 15, 4);
GO

-- Orders
INSERT INTO Orders
    (UserID, OrderDate, OrderStatus, OrderNumber)
VALUES
(1, '2026-09-01', 'Delivered', 1002),
(2, '2026-09-02', 'Shipped', 1003),
(3, '2026-09-03', 'Pending', 1004),
(4, '2026-09-04', 'Shipped', 1005),
(5, '2026-09-05', 'Delivered', 1006),
(1, '2026-09-06', 'Pending', 1007),
(2, '2026-09-08', 'Pending', 1009),
(3, '2026-09-08', 'Pending', 1010);
GO

-- Order Items
INSERT INTO OrderItems
    (OrderID, BookID, Quantity, UnitPrice)
VALUES
(1, 1, 2, 19.99),
(1, 5, 1, 22.99),
(2, 2, 1, 14.99),
(2, 6, 2, 29.99),
(3, 3, 1, 18.99),
(3, 9, 1, 49.99),
(4, 8, 1, 39.99),
(5, 4, 2, 16.99),
(1, 7, 2, 34.99),
(4, 10, 2, 24.99);
GO

