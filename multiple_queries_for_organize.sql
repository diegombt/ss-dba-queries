------------------------------------------------------------------------------------------------------------
-- Nombre y modelo de recuperación de todas las BDs de una instancia
------------------------------------------------------------------------------------------------------------
select name as database_name
      ,recovery_model_desc as recovery_model
  from sys.databases;
go

------------------------------------------------------------------------------------------------------------
-- Detalles de las bases de datos
------------------------------------------------------------------------------------------------------------ 
select name as database_name, d.recovery_model_desc as recovery_model, log_size_mb, row_size_mb, total_size_gb
      ,compatibility_level, state_desc
      ,case is_read_only when 0 then 'False' else 'True' end as is_read_only
  from (select database_id
              ,log_size_mb = cast(sum(case when type_desc = 'LOG' then size end) * 8. / 1024 as decimal(16,2))
              ,row_size_mb = cast(sum(case when type_desc = 'ROWS' then size end) * 8. / 1024 as decimal(16,2))
              ,total_size_gb = cast(sum(size) * 8./1024/1024 as decimal(16,2))
          from sys.master_files with(nolock)
         where 1=1
           -- and database_id > 4 -- For user databases
           -- and database_id = db_id() -- for current db 
         group by database_id
        ) as t
  join sys.databases d on d.database_id = t.database_id
 where 1=1
   and d.name not in ('BDMONITOREO', 'master', 'model', 'msdb', 'tempdb')
 order by total_size_gb desc;
go

------------------------------------------------------------------------------------------------------------
-- Tamaño de la BD actual, segmentado por datafile
------------------------------------------------------------------------------------------------------------
select db_name() as db_name
      ,name as file_name
      ,physical_name
      ,type_desc
      ,(size/128.0) / 1024 as current_size_gb
      ,(size/128.0 - cast(fileproperty(name, 'spaceused') as int)/128.0) / 1024 as free_space_gb
  from sys.database_files
 where type in (0, 1);

------------------------------------------------------------------------------------------------------------
-- Ultima restauración de las BDs en una instancia
-- https://dba.stackexchange.com/a/33705/206202
------------------------------------------------------------------------------------------------------------
with LastRestores as (
  select [d].[name] as database_name
        ,[d].[create_date]
        ,[d].[compatibility_level]
        ,[d].[collation_name]
        ,r.*
        ,row_number() over (partition by d.name order by r.[restore_date] desc) as row_num
    from master.sys.databases d
    left join msdb.dbo.[restorehistory] r on r.[destination_database_name] = d.name
)
select *
  from [LastRestores]
 where [row_num] = 1


------------------------------------------------------------------------------------------------------------
-- Conteo de procesadores e hilos
------------------------------------------------------------------------------------------------------------
DECLARE @xp_msver TABLE (
    [idx] [int] NULL
    ,[c_name] [varchar](100) NULL
    ,[int_val] [float] NULL
    ,[c_val] [varchar](128) NULL
    );

INSERT INTO @xp_msver
EXEC ('[master]..[xp_msver]');
 
WITH [ProcessorInfo]
AS (
    SELECT ([cpu_count] / [hyperthread_ratio]) as [number_of_physical_cpus]
        ,CASE
            WHEN hyperthread_ratio = cpu_count
                THEN cpu_count
            ELSE (([cpu_count] - [hyperthread_ratio]) / ([cpu_count] / [hyperthread_ratio]))
            END as [number_of_cores_per_cpu]
        ,CASE
            WHEN hyperthread_ratio = cpu_count
                THEN cpu_count
            ELSE ([cpu_count] / [hyperthread_ratio]) * (([cpu_count] - [hyperthread_ratio]) / ([cpu_count] / [hyperthread_ratio]))
            END as [total_number_of_cores]
        ,[cpu_count] as [number_of_virtual_cpus]
        ,(
            SELECT [c_val]
            FROM @xp_msver
            WHERE [c_name] = 'Platform'
            ) as [cpu_category]
    FROM [sys].[dm_os_sys_info]
    )
SELECT [number_of_physical_cpus]
    ,[number_of_cores_per_cpu]
    ,[total_number_of_cores]
    ,[number_of_virtual_cpus]
    ,LTRIM(RIGHT([cpu_category], CHARINDEX('x', [cpu_category]) - 1)) as [cpu_category]
FROM [ProcessorInfo];
go

------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------
SELECT (physical_memory_in_use_kb/1024)/1024 as Memory_usedby_Sqlserver_GB FROM sys.dm_os_process_memory;
go

------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------
SELECT ceiling(physical_memory_kb/1024.0/1024.0) as physical_memory_gb FROM master.sys.dm_os_sys_info;
go

------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------
select routine_type, count(*)
  from information_schema.routines
 where routine_type in ('PROCEDURE', 'FUNCTION', 'TABLE')
   and routine_name not in ('fn_diagramobjects','sp_alterdiagram','sp_creatediagram','sp_dropdiagram','sp_helpdiagramdefinition','sp_helpdiagrams','sp_renamediagram','sp_upgraddiagrams')
 group by routine_type;
go

------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------
select count(*) from information_schema.views;
go

------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------
select d.name as mirroreddb
  from sys.database_mirroring m
  join sys.databases d
    on m.database_id = d.database_id
 where m.mirroring_guid is not null
go

------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------
select databasename
      ,string_agg(distinct day(backupstartdate), ', ') as day
  from (select bs.database_name
              ,min(stuff(', ' + datename(weekday, backup_start_date),1,2,'')) as day
              ,avg(datediff(minute, bs.backup_start_date, bs.backup_finish_date)) as avg_time_to_backup
              --,cast(bs.backup_size/1024.0/1024/1024 as decimal(10, 2)) as backupsizegb
              --,cast(bs.backup_size/1024.0/1024 as decimal(10, 2)) as backupsizemb
              --,bs.backup_start_date as backupstartdate
              --,bs.backup_finish_date as backupenddate
              --,bmf.physical_device_name as backupdevicename
          from msdb.dbo.backupset bs with(nolock)
          join msdb.dbo.backupmediafamily bmf with(nolock)
            on bs.media_set_id = bmf.media_set_id
         where 1=1
           and bs.database_name not in ('BDMONITOREO', 'model', 'msdb', 'master')
           and bs.backup_start_date > dateadd(dd, -30, getdate())
           and bs.type = 'D'
           and lower(bmf.physical_device_name) not like '%vmgmacao%'
         group by bs.database_name--, datename(weekday, backup_start_date)
        ) o
 group by databasename

-----------------
select bs.database_name
              --,cast(bs.backup_size/1024.0/1024/1024 as decimal(10, 2)) as backupsizegb
              --,cast(bs.backup_size/1024.0/1024 as decimal(10, 2)) as backupsizemb
        ,stuff((', ' + datename(weekday, backup_start_date), 1, 2, '') as day
              --,bs.backup_start_date as backupstartdate
              --,bs.backup_finish_date as backupenddate
              ,avg(datepart(hour, backup_start_date)) as hour
              ,datediff(minute, bs.backup_start_date, bs.backup_finish_date) as avg_time_to_backup
              --,bmf.physical_device_name as backupdevicename
          from msdb.dbo.backupset bs 
          join msdb.dbo.backupmediafamily bmf
            on bs.media_set_id = bmf.media_set_id
         where 1=1
           and bs.database_name not in ('BDMONITOREO', 'model', 'msdb', 'master')
           and bs.backup_start_date > dateadd(dd, -30, getdate())
           and bs.type = 'D'
           and lower(bmf.physical_device_name) not like '%vmgmacao%'
     group by database_name -- , datename(weekday, backup_start_date)


 STUFF((
    SELECT ', ' + [EmpName] + ':' + CAST([DeptName] as VARCHAR(MAX)) 
    FROM tbl_GroupStringTable 
    WHERE (EmpID = Results.EmpID) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') as NameValues

------------------------------------------------------------------------------------------------------------
-- Validar ultima comprobación de integridad de una BD
------------------------------------------------------------------------------------------------------------
if object_id('tempdb..#dbccs') is not null
  drop table #dbccs;
create table #dbccs (
     id int identity(1, 1) primary key
    ,parentobject varchar(255)
    ,object varchar(255)
    ,field varchar(255)
    ,value varchar(255)
    ,dbname nvarchar(128) null
);

exec sp_msforeachdb N'use [?];
                      set transaction isolation level read uncommitted;
                      insert #dbccs (parentobject, object, field, value)
                      exec (''dbcc dbinfo() with tableresults, no_infomsgs'');
                      update #dbccs set dbname = N''?'' where dbname is null option (recompile);';
 
select distinct field
      ,value
      ,dbname
  from #dbccs
  join sys.databases d on #dbccs.dbname = d.name
 where Field = 'dbi_dbccLastKnownGood'
   and d.create_date < dateadd(dd, -14, getdate());

------------------------------------------------------------------------------------------------------------
-- Validar VLFs del LOG de transacciones
------------------------------------------------------------------------------------------------------------
DECLARE @query varchar(1000),
 @dbname varchar(1000),
 @count int

SET NOCOUNT ON

DECLARE csr CURSOR FAST_FORWARD READ_ONLY
FOR
SELECT name
FROM sys.databases

CREATE TABLE ##loginfo
(
 dbname varchar(100),
 num_of_rows int)

OPEN csr

FETCH NEXT FROM csr INTO @dbname

WHILE (@@fetch_status <> -1)
BEGIN

CREATE TABLE #log_info
(
 RecoveryUnitId tinyint,
 fileid tinyint,
 file_size bigint,
 start_offset bigint,
 FSeqNo int,
[status] tinyint,
 parity tinyint,
 create_lsn numeric(25,0)
)

SET @query = 'DBCC loginfo (' + '''' + @dbname + ''') '

INSERT INTO #log_info
EXEC (@query)

SET @count = @@rowcount

DROP TABLE #log_info

INSERT ##loginfo
VALUES(@dbname, @count)

FETCH NEXT FROM csr INTO @dbname

END

CLOSE csr
DEALLOCATE csr

SELECT dbname,
 num_of_rows
FROM ##loginfo
WHERE num_of_rows >= 50 --My rule of thumb is 50 VLFs. Your mileage may vary.
ORDER BY dbname

DROP TABLE ##loginfo

------------------------------------------------------------------------------------------------------------
-- Uso de CPU por BD
------------------------------------------------------------------------------------------------------------
http://dbadiaries.com/how-to-list-cpu-usage-per-database-in-sql-server

------------------------------------------------------------------------------------------------------------
-- Uso de MEmoria por BD
-- https://blog.sqlauthority.com/2017/05/07/find-sql-server-memory-use-database-objects-interview-question-week-121/
------------------------------------------------------------------------------------------------------------
select case [database_id]
            when 32767 then 'Resource DB'
            else db_name([database_id]) end as [Database Name]
      ,count_big(*) as [Pages in Buffer]
      ,count_big(*)/128 [Buffer Size in MB]
  from sys.dm_os_buffer_descriptors
 group by [database_id]
 order by [Pages in Buffer] desc;

------------------------------------------------------------------------------------------------------------
-- Linked Servers
-- https://gallery.technet.microsoft.com/scriptcenter/Get-List-of-Linked-Server-d6c95d9c
------------------------------------------------------------------------------------------------------------
select ss.server_id
      ,ss.name
      ,case ss.server_id
            when 0 then 'Current Server'
            else 'Remote Server' end as 'Server'
      ,ss.product
      ,ss.provider
      ,ss.catalog
      ,case sl.uses_self_credential
            when 1 then 'Uses Self Credentials'
            else ssp.name end as 'Local Login'
       ,sl.remote_name as 'Remote Login Name'
       ,case when ss.is_rpc_out_enabled = 1 then 'True'
             else 'False' end as 'RPC Out Enabled'
       ,case when ss.is_data_access_enabled = 1 then 'True'
             else 'False' end as 'Data Access Enabled'
       ,ss.modify_date
  from sys.servers ss
  left join sys.linked_logins sl
    on ss.server_id = sl.server_id
  left join sys.server_principals ssp
    on ssp.principal_id = sl.local_principal_id

------------------------------------------------------------------------------------------------------------
-- Availability Group how to determine last Failover time
-- https://dba.stackexchange.com/a/215627/206202
------------------------------------------------------------------------------------------------------------
WITH cte_HADR as (SELECT object_name, CONVERT(XML, event_data) as data
FROM sys.fn_xe_file_target_read_file('AlwaysOn*.xel', null, null, null)
WHERE object_name = 'error_reported'
)

SELECT data.value('(/event/@timestamp)[1]','datetime') as [timestamp],
       data.value('(/event/data[@name=''error_number''])[1]','int') as [error_number],
       data.value('(/event/data[@name=''message''])[1]','varchar(max)') as [message]
FROM cte_HADR
WHERE data.value('(/event/data[@name=''error_number''])[1]','int') = 1480
order by 1 desc

------------------------------------------------------------------------------------------------------------
-- IO Stats || Page Reads/Sec – How many pages are read from disk
-- https://www.sqlshack.com/how-to-analyze-storage-subsystem-performance-in-sql-server/
-- https://simplesqlserver.com/2013/08/13/sys-dm_os_perfomance_counters-demystified/
------------------------------------------------------------------------------------------------------------
with aggregate_io_statistics as (
    select db_name(database_id) as db_name
          ,cast(sum(num_of_bytes_read + num_of_bytes_written)/1048576 as decimal(12, 2)) as io_in_mb
      from sys.dm_io_virtual_file_stats(null, null) as dm_io_stats
     group by database_id
)
select row_number() over(order by io_in_mb desc) as io_rank
      ,db_name
      ,io_in_mb as total_io_mb
      ,cast(io_in_mb/sum(io_in_mb) over() * 100.0 as decimal(5,2)) as io_percent
      ,datediff(day, x.login_time, getdate()) as server_up_days
  from aggregate_io_statistics, sys.dm_exec_sessions x
 where x.session_id = 1
 order by io_rank;


------------------------------------------------------------------------------------------------------------
-- Obtener tamaño histórico de BD en SQL Overview
------------------------------------------------------------------------------------------------------------
with data as (
select datechecked as date
      ,sum(size(mb))/1024 as size
  from sql_overview.dbo.database_info_history
 where databasename = 'tbc_inf_log'
 group by [datechecked
)
select cast(date as date) as datechecked, max(size) as size
  from data
 group by cast(date as date)