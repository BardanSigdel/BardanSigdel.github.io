--Created for Data Warehousing course 
--7/20/2023


--Create the Database BoulderBoulders, if not exist, create. If exist, use the database.

IF NOT EXISTS(
	SELECT name FROM master.dbo.sysdatabases 
	WHERE name = N'BoulderBoulders')
	
	CREATE DATABASE BoulderBoulders

	GO
USE BoulderBoulders

-- Alter the path so the script can find the CSV files 

DECLARE @data_path NVARCHAR(MAX);
SELECT @data_path = 'C:\Users\barda\OneDrive\Desktop\Warehousing\Project Material\Part 2\Build';

-- Delete existing tables

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Game'
       )
	DROP TABLE Game;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'TicketOrder'
       )
	DROP TABLE TicketOrder;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Ticketholder'
       )
	DROP TABLE Ticketholder;

-- Create tables

-- Create Game table
CREATE TABLE Game (
    gameid INT PRIMARY KEY,
    gamedate DATE,
    opponentcity VARCHAR(100),
    opponentmascot VARCHAR(100),
    marketingpromotion VARCHAR(200),
    rivalry_flag BIT,
    regseason_flag BIT,
    playoff_flag BIT
);

-- Create Ticketholder table
CREATE TABLE Ticketholder (
    ticketholderid INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender CHAR(6),
    dob DATE,
    ethnicity VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50)
);

-- Create TicketOrder table
CREATE TABLE TicketOrder (
    saleid INT PRIMARY KEY,
    ticketholderid INT,
    gameid INT,
    purchase_date DATE,
    ticketprice_perticket INT,
    ticket_quantity INT,
    FOREIGN KEY (ticketholderid) REFERENCES Ticketholder(ticketholderid),
    FOREIGN KEY (gameid) REFERENCES Game(gameid)
);

-- Load data

EXECUTE (N'BULK INSERT Game FROM ''' + 'C:\Users\barda\OneDrive\Desktop\Warehousing\Project Material\Part 2\Build\' + N'Game.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

--
EXECUTE (N'BULK INSERT Ticketholder FROM ''' + 'C:\Users\barda\OneDrive\Desktop\Warehousing\Project Material\Part 2\Build\' + N'Ticketholder.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT TicketOrder FROM ''' + 'C:\Users\barda\OneDrive\Desktop\Warehousing\Project Material\Part 2\Build\' + N'TicketOrder.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

-- List table names and row counts for confirmation

GO
SET NOCOUNT ON
SELECT 'Game' AS "Table", COUNT(*) AS "Rows"	FROM Game	          UNION
SELECT 'Ticketholder',    COUNT(*)				FROM Ticketholder         UNION
SELECT 'TicketOrder',     COUNT(*)				FROM TicketOrder 
ORDER BY 2;
SET NOCOUNT OFF
GO
