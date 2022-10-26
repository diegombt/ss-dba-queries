############################################################################################################
# Backup a SQL server DB, using Backup-DbaDatabase from dbatools and DatabaseBackup from Ola Hallengren
############################################################################################################
$new = "localhost\sonder"
$old = $instance = "localhost"
$servers = $old, $new

# Backup databases
Get-DbaDatabase -SqlInstance $servers | Backup-DbaDatabase

# Recover backup history
Get-DbaDbBackupHistory -SqlInstance "vmpgalapa" -Since '2020-06-04 00:00:00'

# Backup using Ola Hallengren script
$servers | Invoke-DbaQuery -Query 'EXECUTE master.dbo.DatabaseBackup
           @Databases = ''USER_DATABASES''
          ,@Directory = ''\\vmgmacao\BDS-SQL\Tot''
          ,@BackupType = ''FULL''
          ,@Verify = ''Y''
          ,@Compress = ''Y''
          ,@CheckSum = ''Y''
          ,@CopyOnly = ''Y'''

############################################################################################################
# Get SQL Server product version, using Invoke-DbaQuery script
############################################################################################################
$servers | Invoke-DbaQuery -Query 'select @@servername, serverproperty(''ProductVersion'')' | Out-GridView

############################################################################################################
# Backup JOBS from SQL Server Agent Service to file
############################################################################################################
Get-DbaAgentJob -SqlInstance $old | Export-DbaScript -Path C:\temp\jobs.sql



puinawai
vmpargo
vmpfrancia
vmpjuliet
vmpnarino
vmpsanpedro
sqlclu02
vdemeter
vcronos


vmprubosher
vmpruchile
vmpruduina2
vmprueritrea
vmprufitri
vmpruguatemala
vmpruguinea
vmpruguyana
vmprupolonia
vmprushangalele
vmprusurinam
vmpruviena


vmdcambo
vmdosiris
vmdpanama
vmdtrinidad
vmdturquia
vmducolomb
vmduruguay