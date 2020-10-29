------------------------------------------------------------------------------------------------------------
-- Show backup history
-- https://www.dbrnd.com/2016/10/sql-server-script-to-find-all-backup-history-information-to-sync-problem/
------------------------------------------------------------------------------------------------------------
select bs.database_name as databasename
      ,case bs.type
            when 'D' then 'Full'
            when 'I' then 'Differential'
            when 'L' then 'Transaction log'
        end as backuptype
      ,cast(datediff(second, bs.backup_start_date,bs.backup_finish_date)
                 as varchar(4)) + ' ' + 'seconds' as totaltimetaken
      ,bs.backup_start_date as backupstartdate
      ,cast(bs.first_lsn as varchar(50)) as firstlsn
      ,cast(bs.last_lsn as varchar(50)) as lastlsn
      ,bmf.physical_device_name as physicaldevicename
      ,cast(cast(bs.backup_size / 1000000 as int) as varchar(14)) + ' ' + 'mb' as backupsize
      ,bs.server_name as servername
      ,bs.recovery_model as recoverymodel
      ,bs.is_copy_only
  from msdb.dbo.backupset as bs
  join msdb.dbo.backupmediafamily as bmf
    on bs.media_set_id = bmf.media_set_id
 where 1=1
   -- and bs.database_name = 'database'
   -- and bs.type in ('D', 'I')
   -- and backup_start_date between '2020-03-31' and '2020-04-01'
 order by backup_start_date desc, backup_finish_date

------------------------------------------------------------------------------------------------------------
-- Show database size and last backup execution
-- Excludes system databases
-- https://stackoverflow.com/a/18014581/2639633
------------------------------------------------------------------------------------------------------------
declare @sql nvarchar(4000)
declare @sys_databases int
set @sys_databases = 0 -- 0 if you don't need system databases information

if object_id('tempdb.dbo.#space') is not null
    drop table #space

create table #space (database_id int primary key, data_used_size decimal(16,2), log_used_size decimal(16,2))

select @sql = stuff((
    select '
       use [' + d.name + ']
    insert into #space (database_id, data_used_size, log_used_size)
    select db_id()
          ,sum(case when [type] = 0 then space_used end)
          ,sum(case when [type] = 1 then space_used end)
      from (select s.[type], space_used = sum(fileproperty(s.name, ''spaceused'') * 8. / 1024)
              from sys.database_files s
             group by s.[type]
            ) t;'
      from sys.databases d
     where d.[state] = 0
       for xml path(''), type).value('.', 'nvarchar(max)'), 1, 2, '')

exec sys.sp_executesql @sql

select d.database_id
      ,d.name
      ,d.state_desc
      ,d.recovery_model_desc
      ,t.total_size
      ,t.data_size
      ,s.data_used_size
      ,t.log_size
      ,s.log_used_size
      ,bu.full_last_date
      ,bu.full_size
      ,bu.log_last_date
      ,bu.log_size
  from (select database_id
              ,log_size = cast(sum(case when [type] = 1 then size end) * 8. / 1024 as decimal(16,2))
              ,data_size = cast(sum(case when [type] = 0 then size end) * 8. / 1024 as decimal(16,2))
              ,total_size = cast(sum(size) * 8. / 1024 as decimal(16,2))
          from sys.master_files
         where database_id > case when @sys_databases = 0 then 4 else 0 end
         group by database_id
        ) t
  join sys.databases d on d.database_id = t.database_id
  left join #space s on d.database_id = s.database_id
  left join 
       (select database_name
              ,full_last_date = max(case when [type] = 'D' then backup_finish_date end)
              ,full_size = max(case when [type] = 'D' then backup_size end)
              ,log_last_date = max(case when [type] = 'L' then backup_finish_date end)
              ,log_size = max(case when [type] = 'L' then backup_size end)
          from (select s.database_name
                      ,s.[type]
                      ,s.backup_finish_date
                      ,backup_size = cast(case when s.backup_size = s.compressed_backup_size
                                               then s.backup_size
                                               else s.compressed_backup_size
                                           end / 1048576.0 as decimal(16,2)) -- For 2005 versions use only backup_size column
                      ,rownum = row_number() over (partition by s.database_name, s.[type] order by s.backup_finish_date desc)
                  from msdb.dbo.backupset s
                 where s.[type] in ('D', 'L')
          ) f
          where f.rownum = 1
          group by f.database_name
        ) bu on d.name = bu.database_name
 order by t.total_size desc