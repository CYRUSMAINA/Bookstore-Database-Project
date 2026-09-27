 Online Bookstore Database
A SQL Server database project designed for an online bookstore to manage customers, books, inventory, orders, order items, returns, and order activity.
This project demonstrates practical SQL Server database development, including database design, relationships, constraints, sequences, indexes, triggers, stored procedures, functions, cursors, reporting, and error handling.
 Features
- Customer and user management
- Book, author, and category management
- Inventory tracking
- Order and order-item management
- Book return processing
- Order status auditing
- Automatic inventory updates using triggers
- Automatic order number generation using a sequence
- Stored procedures for common business operations
- SQL functions for reusable calculations
- Cursor-based weekly order reporting
- Indexes for frequently searched data
- Primary key, foreign key, UNIQUE, and CHECK constraints
- Error handling using TRY/CATCH and THROW
Technologies
- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- Relational Database Design
- ERD / Database Diagrams
Database Design
The database is designed around the main business processes of an online bookstore.
 Core Tables

1. Users – stores customer information.
2. Authors – stores book authors.
3. Categories– organizes books by category.
4. Books – stores book details, prices, authors, and categories.
5. Inventory – tracks stock levels and reorder levels.
6. Orders  – stores customer orders and order status.
7. Order Items – stores the books and quantities included in each order.
8. Returns – records returned books and return information.
9. Order Audit – records changes to order status.

The Entity Relationship Diagram (ERD) shows the relationships between these tables.
 SQL Server Implementation
This project was implemented using SQL Server and T-SQL.

The original academic project used Oracle database concepts such as packages, procedures, functions, cursors, sequences, and triggers. For this portfolio version, the database functionality was redesigned using SQL Server equivalents.

Key implementations include:

- Stored procedures for business operations
- Scalar-valued functions for reusable calculations
- SQL Server sequences for order number generation
- Triggers for inventory updates and order auditing
- Cursors for weekly report generation
- TRY/CATCH and THROW for error handling
- Primary key, foreign key, UNIQUE, and CHECK constraints for data integrity

## Project Structure

```text
Bookstore-Database/
01_Database/----------------Database.sql
02_Tables/----------Tables.sql
03_Sample_Data/------------ Sample_Data.sql
04_Sequence/-------------OrderNumberSequence.sql
05_Indexes/-------------- Indexes.sql
06_Triggers/----------------- Triggers.sql
07_Stored_Procedures/----------------Stored_Procedures.sql
08_Functions/--------------Functions.sql
 09_Reports_Cursor/------------- Weekly_Order_Report.sql
10_Testing/-------------Test_Cases.sql
ERD/----------------Bookstore_ERD
README.md

Testing
The database functionality was tested using both valid and invalid scenarios.

Tested areas include:

- Invalid UserID handling
- Invalid OrderID handling
- Invalid return quantity handling
- Order status auditing
- Automatic inventory reduction when an order item is added
- Automatic inventory restoration when an item is returned
- Foreign key constraint enforcement
- CHECK constraint enforcement
- Order number generation using the sequence
- Stored procedure execution
- Function execution
- Cursor-based weekly report generation

Error handling was verified using SQL Server TRY...CATCH  and  THROW.
Functions
-fn_GetOrderTotal  – calculates the total value of an order.
- fn_GetInventoryQuantity – returns the current inventory quantity for a book.
- fn_GetReturnedQuantity – calculates the quantity returned for an order item.

Triggers
- trg_ReduceInventory – automatically reduces inventory when an order item is added.
- trg_RestoreInventory – automatically restores inventory when a return is processed.
- trg_AuditOrderStatus – records order status changes in the audit table.

 Entity Relationship Diagram
The ERD illustrates the relationships between the nine core tables and shows how users, books, inventory, orders, order items, returns, and auditing are connected.

The project is organized into separate SQL scripts so each database component can be reviewed and executed independently.

01) Database – database creation
02) Tables – table definitions and constraints
03) Sample Data – sample data
04) Sequence – order number sequence
05) Indexes – performance indexes
06) Triggers – automated database actions
07)Stored Procedures – business operations and reporting
08) Functions – reusable calculations
09) Reports Cursor – weekly reporting and cursor implementation
10) Testing – functional and constraint testing

 Project Outcome
This project demonstrates practical database development using SQL Server and T-SQL.
It shows how database design and programmable database objects can be used to support real-world bookstore operations while maintaining data integrity, automating business rules, and generating useful reports.

The project was also tested using both successful and error scenarios to verify that the database behaves as expected.


Author
Cyrus Maina
This project was developed as a portfolio project to demonstrate practical SQL Server and database development skills.
