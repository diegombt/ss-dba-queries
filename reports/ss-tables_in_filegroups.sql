------------------------------------------------------------------------------------------------------------
-- List of Table in Filegroup with table size in SQL Server
-- Know list of table under each file group along with size of that table and name of clustered index if any
-- http://blog.extreme-advice.com/2013/01/17/list-of-table-in-filegroup-with-table-size-in-sql-server/
------------------------------------------------------------------------------------------------------------
SELECT filegroup_name(au.data_space_id) as FileGroupName
      ,object_name(Parti.object_id) as TableName
      ,ind.name as ClusteredIndexName
      ,au.total_pages/128 as TotalTableSizeInMB
      ,au.used_pages/128 as UsedSizeInMB
      ,au.data_pages/128 as DataSizeInMB
  from sys.allocation_units au
  join sys.partitions Parti
    on au.container_id =
       case when au.type in(1, 3)
       then Parti.hobt_id
       else Parti.partition_id end
  left join sys.indexes ind
    on ind.object_id = Parti.object_id
   and ind.index_id = Parti.index_id
 order by 1, 4 desc