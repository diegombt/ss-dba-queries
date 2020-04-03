------------------------------------------------------------------------------------------------------------
-- Shows performance by database file, ordered by database name
------------------------------------------------------------------------------------------------------------
select m.name as database_name
      ,files.physical_name
      ,files.name file_name
      ,stats.num_of_writes
      ,(1.0 * stats.io_stall_write_ms / stats.num_of_writes) as avg_write_stall_ms
      ,stats.num_of_reads
      ,(1.0 * stats.io_stall_read_ms / stats.num_of_reads) as avg_read_stall_ms
  from sys.dm_io_virtual_file_stats(null, null) as stats
  join master.sys.master_files as files
    on stats.database_id = files.database_id
   and stats.file_id = files.file_id
  join master.sys.databases m
    on m.database_id = files.database_id
 where 1=1
    -- and files.type_desc = 'ROWS'
 order by 1 desc

--------------------------------------------------------------------------------------
-- This query hits the dynamic management function (DMF) sys.dm_io_virtual_file_stats 
-- for all of the TempDB data files and lists out how fast they’re responding to write
-- (and read) requests
--------------------------------------------------------------------------------------
-- For additional information look at this articles
-- http://www.brentozar.com/sql/tempdb-performance-and-configuration/
-- http://www.brentozar.com/blitz/tempdb-data-files/
--------------------------------------------------------------------------------------
select files.physical_name
      ,files.name
      ,stats.num_of_writes
      ,(1.0 * stats.io_stall_write_ms / stats.num_of_writes) as avg_write_stall_ms
      ,stats.num_of_reads
      ,(1.0 * stats.io_stall_read_ms / stats.num_of_reads) as avg_read_stall_ms
  from sys.dm_io_virtual_file_stats(2, null) as stats
  join master.sys.master_files as files
    on stats.database_id = files.database_id
   and stats.file_id = files.file_id
 where files.type_desc = 'ROWS'