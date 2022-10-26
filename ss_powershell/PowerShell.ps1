# PowerShell
Invoke-Command -ComputerName VMPRONDON -ScriptBlock {Get-Service | select -property name, starttype | Where name -eq "MSSQLSERVER"}

# Process Utilities - PsService –> Descargar
PsService \\PUINAWAI config MSSQLSERVER | find "DEMAND_START"

# -----------------------------------------------------------------------------------------------------------
# Validar clusters de almacenamiento compartido
# https://www.mssqltips.com/sqlservertip/3154/monitor-a-sql-server-cluster-using-powershell/
# -----------------------------------------------------------------------------------------------------------
Import-Module FailoverClusters

Get-ClusterGroup -Cluster sqlclu03 | Format-List -Property *

Get-ClusterResource -Cluster sqlclu03 | 
Where-Object {$_.OwnerGroup -like "SQL Server*"} |
Sort-Object -Property OwnerGroup

# -----------------------------------------------------------------------------------------------------------
# Validar espacio total y disponible en un servidor
# https://stackoverflow.com/a/17127030/2639633
# https://binarynature.blogspot.com/2010/04/powershell-version-of-df-command.html
# -----------------------------------------------------------------------------------------------------------
$cred = Get-Credential -Credential 'compensar\macdmbernalt'
$servers = 'vmpruacra', 'vmpruindo', 'vmpruanadir', 'vmpruerevan'

Get-DiskFree -Credential $cred -cn $servers -Format | ? { $_.Type -like '*fixed*' } | select * -ExcludeProperty Type | Out-GridView -Title 'Windows Servers Storage Statistics'

'db01','dc01','sp01' | Get-DiskFree -Credential $cred -Format | Format-Table -GroupBy Name -AutoSize

# -----------------------------------------------------------------------------------------------------------
# Obtener numero de procesadores e información sobre la arquitectura de un equipo remoto
# -----------------------------------------------------------------------------------------------------------
Get-WmiObject -ComputerName vmptumarado -class Win32_processor | ft systemname,Name,DeviceID,NumberOfCores,NumberOfLogicalProcessors, Addresswidth

# -----------------------------------------------------------------------------------------------------------
# Obtener memoria RAM en GB
# https://community.spiceworks.com/scripts/show/1020-get-amount-of-memory-on-remote-machine
# -----------------------------------------------------------------------------------------------------------
[math]::round((get-wmiobject -class Win32_ComputerSystem -namespace "root\CIMV2" -computername vmptumarado).TotalPhysicalMemory/1024/1024/1024, 0)

# -----------------------------------------------------------------------------------------------------------
# Obtener información de sistema operativo
# https://morgantechspace.com/2017/09/how-to-find-windows-os-version-using-powershell.html
# -----------------------------------------------------------------------------------------------------------
Get-WmiObject Win32_OperatingSystem -ComputerName vmptumarado | Select PSComputerName, Caption, OSArchitecture, Version, BuildNumber | FL

# -----------------------------------------------------------------------------------------------------------
# Get failover events
# https://dba.stackexchange.com/a/144559/206202
# -----------------------------------------------------------------------------------------------------------
Get-winEvent -ComputerName vcarina -filterHashTable @{logname ='Microsoft-Windows-FailoverClustering/Operational'; id=1641} | Out-GridView -Title 'WS Failover Events'

# -----------------------------------------------------------------------------------------------------------
# Get Cluster Configuration Threshold and Delay Settings
# https://www.virtual-dba.com/always-on-changing-cluster-configuration/
# -----------------------------------------------------------------------------------------------------------
get-cluster | fl *subnet*

# -----------------------------------------------------------------------------------------------------------
# Last Good CheckDB
# -----------------------------------------------------------------------------------------------------------
$allservers = Get-DbaRegServer -SqlInstance vmpfrancia | Select-Object -Unique -ExpandProperty ServerName
$allservers | Get-DbaLastGoodCheckDb -SqlCredential compensar\macdmbernalt -ExcludeDatabase "tempdb" | Out-GridView -Title 'Last Good CheckDB'

# -----------------------------------------------------------------------------------------------------------
# Last Backup
# -----------------------------------------------------------------------------------------------------------
$allservers = Get-DbaRegServer -SqlInstance vmpfrancia | Select-Object -Unique -ExpandProperty ServerName
$allservers | Get-DbaLastBackup | Select-Object * | Out-Gridview

# -----------------------------------------------------------------------------------------------------------
# Encontrar todas las instancias de un servidor
# -----------------------------------------------------------------------------------------------------------
Find-DbaInstance -ComputerName vmprutiber, vmprumayor | out-gridview

# -----------------------------------------------------------------------------------------------------------
# Conectarse en modo solo lectura
# -----------------------------------------------------------------------------------------------------------
$server = Connect-DbaInstance vmprondon -ApplicationIntent ReadOnly
Get-DbaDbRoleMember -SqlInstance $server | out-gridview

# -----------------------------------------------------------------------------------------------------------
# Validar campos identity de una BD
# -----------------------------------------------------------------------------------------------------------
Test-DbaIdentityUsage -SqlInstance vmprhesbdb -Database tbc_inf_log | out-gridview

# -----------------------------------------------------------------------------------------------------------
# Validar usuarios de un grupo de dominio
# -----------------------------------------------------------------------------------------------------------
Net Group "G-Adm BD" /domain | Out-GridView

# -----------------------------------------------------------------------------------------------------------
# Muestra las BDs de las instancias que carecen de un respaldo reciente del log de transacciones
# -----------------------------------------------------------------------------------------------------------
Get-DbaDatabase $servers | Where-Object -FilterScript { $_.LastLogBackup -le ((get-date).AddHours(-1)) -AND $_.RecoveryModel -ne 'Simple' } | Out-GridView