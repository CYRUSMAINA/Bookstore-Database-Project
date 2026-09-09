USE Bookstore_Project;
GO

-- Index for book title searches
CREATE INDEX IX_Books_Title
ON Books (Title);
GO

-- Index for ISBN searches
CREATE INDEX IX_Books_ISBN
ON Books (ISBN);
GO

-- Index for finding orders by user
CREATE INDEX IX_Orders_UserID
ON Orders (UserID);
GO