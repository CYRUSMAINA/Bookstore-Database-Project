USE Bookstore_Project;
GO

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    CreatedDate DATE NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    ISBN VARCHAR(20) UNIQUE,
    AuthorID INT NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PublishedDate DATE,

    CONSTRAINT FK_Books_Authors
        FOREIGN KEY (AuthorID)
        REFERENCES Authors(AuthorID),

    CONSTRAINT FK_Books_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
GO

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL UNIQUE,
    QuantityInStock INT NOT NULL,
    ReorderLevel INT NOT NULL,
    LastUpdated DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Inventory_Books
        FOREIGN KEY (BookID)
        REFERENCES Books(BookID),

    CONSTRAINT CK_Inventory_Quantity
        CHECK (QuantityInStock >= 0),

    CONSTRAINT CK_Inventory_ReorderLevel
        CHECK (ReorderLevel >= 0)
);
GO

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate DATE NOT NULL DEFAULT GETDATE(),
    OrderStatus VARCHAR(50) NOT NULL,
    OrderNumber INT NULL,

    CONSTRAINT FK_Orders_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID)
);
GO

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT FK_OrderItems_Books
        FOREIGN KEY (BookID)
        REFERENCES Books(BookID),

    CONSTRAINT CK_OrderItems_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_OrderItems_UnitPrice
        CHECK (UnitPrice >= 0)
);
GO

CREATE TABLE Returns (
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    OrderItemID INT NOT NULL,
    ReturnDate DATE NOT NULL DEFAULT GETDATE(),
    Quantity INT NOT NULL,
    ReturnReason VARCHAR(255),
    ReturnStatus VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Returns_OrderItems
        FOREIGN KEY (OrderItemID)
        REFERENCES OrderItems(OrderItemID),

    CONSTRAINT CK_Returns_Quantity
        CHECK (Quantity > 0)
);
GO

CREATE TABLE OrderAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    OldStatus VARCHAR(50),
    NewStatus VARCHAR(50),
    ChangedDate DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_OrderAudit_Orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
);
GO