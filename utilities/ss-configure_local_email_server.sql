------------------------------------------------------------------------------------------------------------
-- Configurar servidor local de correos
-- https://gist.github.com/raelgc/6031306
-- Configurar correo en SQL Server para pruebas
-- https://www.sqlshack.com/configure-database-mail-sql-server/
------------------------------------------------------------------------------------------------------------
USE master
Go
EXEC sp_configure 'show advanced options', 1 --Enable advance option
Go
RECONFIGURE
Go
EXEC sp_configure 'Database Mail XPs', 1 --Enable database Mail option
Go
RECONFIGURE
Go
EXEC sp_configure 'show advanced options', 0 --Disabled advanced option
Go
RECONFIGURE
Go

EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'Database Mail Default SMTP account'
  , @description = 'This account will be used to send database mail'
  , @email_address = 'dba@diego.com'
  , @display_name = 'DBA Support'
  , @replyto_address = ''
  , @mailserver_type = 'SMTP'
  , @mailserver_name = 'localhost'
  , @port = 25
Go

-- Create a Database Mail profile
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'Database Mail Profile'
  , @description = 'This profile will be used to send database mail'
Go

-- Add the account to the profile
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Database Mail Profile'
  , @account_name = 'Database Mail Default SMTP account'
  , @sequence_number = 1
Go

-- listo ya encontre otro servidor seria vmpruturkana (primario) vmpruvolta(secundario) y el listener es vasambleapru y ahi esta como tal la bd de asamblea y ahi si estan los logins replicados 