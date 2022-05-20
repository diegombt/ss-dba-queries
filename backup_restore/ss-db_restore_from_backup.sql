-------------------------------------------------------------------------------------------------------------------------------------------------
-- Restore backup
-------------------------------------------------------------------------------------------------------------------------------------------------
USE [master]
GO

RESTORE DATABASE [log_shipping] 
   FROM DISK = N'\\shared_route\backups\log_shipping.bak' 
   WITH FILE = 1
       ,MOVE N'log_shipping_data' TO N'G:\data_sql\log_shipping.mdf'
       ,MOVE N'log_shipping_log' TO N'H:\log_sql\log_shipping.ldf'
       ,NORECOVERY
       ,NOUNLOAD
       ,STATS = 5
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Validates backup 
-------------------------------------------------------------------------------------------------------------------------------------------------
RESTORE VERIFYONLY FROM DISK = N'\\shared_route\backup.bak' WITH NOUNLOAD, NOREWIND

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Redirected SQL restore fails with - A previous restore operation was interrupted and did not complete processing on file 'file_name'.
-- https://www.veritas.com/support/en_US/article.000088126
-------------------------------------------------------------------------------------------------------------------------------------------------
EXEC SP_RESETSTATUS @DBName='DATABASE';
DBCC DBRECOVER ('DATABASE');

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Full restore
-------------------------------------------------------------------------------------------------------------------------------------------------
USE [master]
GO

RESTORE DATABASE [log_shipping]
   FROM DISK = N'\\shared_route\backups\log_shipping_full_backup.bak' 
   WITH FILE = 1
       ,NORECOVERY
       ,NOUNLOAD
       ,STATS = 5
GO

RESTORE LOG [log_shipping] FROM  DISK = N'\\shared_route\backups\log_shipping_20220520221721.trn' 
   WITH NORECOVERY
GO

RESTORE LOG [log_shipping] FROM  DISK = N'\\shared_route\backups\log_shipping_20220520223001.trn' 
   WITH NORECOVERY
GO

RESTORE LOG [log_shipping] FROM  DISK = N'\\shared_route\backups\log_shipping_20220520223337.trn' 
   WITH RECOVERY -- –––––––––- → Validate where DB needs to be in recovery
GO