------------------------------------------------------------------------------------------------------------
-- Shows index fragmentation
------------------------------------------------------------------------------------------------------------
select s.[name] +'.'+t.[name] as table_name
      ,i.name as index_name
      ,index_type_desc
      ,round(avg_fragmentation_in_percent,2) as avg_fragmentation_in_percent
      ,record_count as table_record_count
  from sys.dm_db_index_physical_stats(db_id(), null, null, null, 'SAMPLED') ips
  join sys.tables t
    on t.[object_id] = ips.[object_id]
  join sys.schemas s
    on t.[schema_id] = s.[schema_id]
  join sys.indexes i
    on (ips.object_id = i.object_id)
   and (ips.index_id = i.index_id)
 where 1=1
   -- and t.name in ('incidents', 'logactions', 'logevents', 'tasks')
 order by avg_fragmentation_in_percent desc
