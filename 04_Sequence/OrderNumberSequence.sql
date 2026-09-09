USE Bookstore_Project;
GO

-- Sequence for generating unique order numbers
CREATE SEQUENCE OrderNumberSequence
    AS INT
    START WITH 1001
    INCREMENT BY 1;
GO