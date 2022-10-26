/***********************************************************************************************************
 * 
 * https://www.stellarinfo.co.in/kb/how-to-repair-corrupted-sql-server-database.php
 ***********************************************************************************************************/
ALTER DATABASE (Test_Database) SET EMERGENCY
GO

ALTER DATABASE Test_Database SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DBCC CHECKDB (Test_Database, REPAIR_ALLOW_DATA_LOSS) WITH ALL_ERRORMSGS, NO_INFOMSGS;
GO

ALTER DATABASE Test_Database SET MULTI_USER
GO