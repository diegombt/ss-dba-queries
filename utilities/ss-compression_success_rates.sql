------------------------------------------------------------------------------------------------------------
-- Page compression success rate
-- https://www.sqlskills.com/blogs/paul/the-curious-case-of-tracking-page-compression-success-rates/
------------------------------------------------------------------------------------------------------------
select distinct object_name (i.object_id) as [Table]
      ,i.name as [Index]
      ,p.partition_number as [Partition]
      ,page_compression_attempt_count
      ,page_compression_success_count
      ,page_compression_success_count * 1.0 
       / page_compression_attempt_count as [SuccessRate]
  from sys.indexes as i
  join sys.partitions as p
    on p.object_id = i.object_id
 cross apply sys.dm_db_index_operational_stats 
       (db_id(), i.object_id, i.index_id, p.partition_number) as ios
 where 1=1
   and p.data_compression = 2
   and page_compression_attempt_count > 0
 order by [SuccessRate];