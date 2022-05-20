------------------------------------------------------------------------------------------------------------
-- Table and Indexes compression
-- https://stackoverflow.com/questions/16988326/query-all-table-data-and-index-compression
------------------------------------------------------------------------------------------------------------
select t.name as 'table'
      ,p.partition_number as partition
      ,p.data_compression_desc as compression
  from sys.partitions as p
  join sys.tables as t
    on t.object_id = p.object_id
 where p.index_id in (0, 1);

-- Indexes compression
select t.name as 'table'
      ,i.name as 'index'
      ,p.partition_number as partition
      ,p.data_compression_desc as compression
  from sys.partitions as p
  join sys.tables as t
    on t.object_id = p.object_id
  join sys.indexes as i
    on i.object_id = p.object_id
   and i.index_id = p.index_id
 where p.index_id > 1;