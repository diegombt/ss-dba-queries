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
  from sys.dm_io_virtual_file_stats(NULL, NULL) as stats
  join master.sys.master_files as files
    on stats.database_id = files.database_id
   and stats.file_id = files.file_id
  join master.sys.databases m
    on m.database_id = files.database_id
 where 1=1
    -- and files.type_desc = 'ROWS'
 order by 1 desc