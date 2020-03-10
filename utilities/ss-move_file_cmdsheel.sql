------------------------------------------------------------------------------------------------------------
-- Move a file through Windows command shell 
------------------------------------------------------------------------------------------------------------
declare @source_file as varchar(500);  
declare @destination_file as varchar(500);  
declare @cmd as varchar(500); 

set @source_file = '\\192.168.10.194\soporte$\Adminservidores\Tools\Microsoft\SQL\2012\Service Pack\diego.txt';
set @destination_file = '\\192.168.10.194\soporte$\Adminservidores\Tools\Microsoft\SQL\2012\Service Pack\hola\';

set @cmd = 'copy "' + @source_file + '" "' + @destination_file + '"';  

exec master.dbo.xp_cmdshell @cmd;