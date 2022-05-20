# Listado de servidores
$servers = 'vmpruafganistan', 'vmpruazerbaiyan', 'vcarina'
# Modificar el nombre del JOB que se desea habilitar
$sqlAgentJob = 'DatabaseBackup - USER_DATABASES - LOG'

# Vea el estado de todos los JOBs en cada instancia
Get-DbaAgentJob -SqlInstance $servers -Job $sqlAgentJob | Out-GridView
# Habilite el JOB de ser necesario, remueva WhatIf para ejecutar
Set-DbaAgentJob -SqlInstance $servers -Job $sqlAgentJob -Enabled -WhatIf

$Results = ForEach ($server in $servers) {
  Get-SqlAgent -ServerInstance $server | Get-SqlAgentJob -name $sqlAgentJob | Get-SqlAgentJobSchedule | Select @{Name='Server';Expression={$server}}, Name, Enabled, ActiveStartDate, ActiveEndDate
  # Agregar a la línea anterior si se desea filtrar un nombre especifico de una programación → | Where-Object {$_.Name -Like 'Recurring'}
}
# Mostrar la programación de los JOBs en cada servidor
$Results | Out-GridView

# Ajustar cada una de las programaciones que se encontraron en los JOBs
# Se debe tener en cuenta que un JOB puede tener varias programaciones, por lo que idealmente deberían llamarse igual en todos los servidores
# También se puede filtrar el resultado por nombre
# Asegurese de tener desplegado DBATools
ForEach ($schedule in $Results){
  # Remover WhatIf si está seguro de habilitar las programaciones
  Set-DbaAgentSchedule -SqlInstance $schedule.Server -Job $sqlAgentJob -ScheduleName $schedule.Name -Enabled -WhatIf
}