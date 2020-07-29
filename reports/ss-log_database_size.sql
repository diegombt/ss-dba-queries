------------------------------------------------------------------------------------------------------------
-- Register database size information
------------------------------------------------------------------------------------------------------------
-- 1. Create temporary table to store information
------------------------------------------------------------------------------------------------------------
use [master] -- Define database
go

-- Create temporary table
create table database_size (
  database_name varchar(20)
 ,log_size_gb decimal(16,2)
 ,row_size_gb decimal(16,2)
 ,total_size_gb decimal(16,2)
 ,timestamp datetime
)
go

alter table [dbo].[database_size] rebuild partition = all with (data_compression = page)
go

------------------------------------------------------------------------------------------------------------
-- 2. Insert transactions into temporary table
------------------------------------------------------------------------------------------------------------
insert into database_size
select name as database_name, log_size_gb, row_size_gb, total_size_gb, current_timestamp as timestamp
  from (select database_id
              ,log_size_gb = cast(sum(case when type_desc = 'LOG' then size end) * 8. / 1024 / 1024 as decimal(16,2))
              ,row_size_gb = cast(sum(case when type_desc = 'ROWS' then size end) * 8. / 1024 / 1024 as decimal(16,2))
              ,total_size_gb = cast(sum(size) * 8./1024/1024 as decimal(16,2))
			  ,current_timestamp as timestamp
          from sys.master_files with(nolock)
         where 1=1
           -- and database_id > 4 -- For user databases
           -- and database_id = db_id() -- For current db 
         group by database_id
        ) as t
  join sys.databases d on d.database_id = t.database_id
 where 1=1
   -- and d.name = 'ComClientes'; -- For desired database
   and d.name not in ('BDMONITOREO', 'master', 'model', 'msdb', 'tempdb');
waitfor delay '00:01:00'; -- Interval time
go 100 -- Maximum number of executions

------------------------------------------------------------------------------------------------------------
-- 3. Fast analysis
------------------------------------------------------------------------------------------------------------
select avg(log_size_gb) as avg_log_size_gb
      ,min(log_size_gb) as avg_log_size_gb
      ,max(log_size_gb) as avg_log_size_gb
      ,avg(row_size_gb) as avg_row_size_gb
      ,avg(total_size_gb) as avg_total_size_gb
      ,count(*) as rows
  from database_size
go

------------------------------------------------------------------------------------------------------------
-- 4. Drop table
------------------------------------------------------------------------------------------------------------
--if exists (select 1 from sys.tables where name = 'database_size')
--drop table database_size
--go