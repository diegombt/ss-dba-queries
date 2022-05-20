------------------------------------------------------------------------------------------------------------
-- Get index information for objects with non default fill factor
-- https://sqlmaestros.com/script-find-fillfactor-of-all-indexes-in-a-database/
------------------------------------------------------------------------------------------------------------
with index_info as (
  select db_name() as Database_Name
        ,i.object_id
        ,i.index_id
        ,sc.name as Schema_Name
        ,o.name as Table_Name
        ,o.type_desc
        ,i.name as Index_Name
        ,i.type_desc as Index_Type
        ,i.fill_factor
    from sys.indexes i
    join sys.objects o on i.object_id = o.object_id
    join sys.schemas sc on o.schema_id = sc.schema_id
   where i.name is not null
     and o.type = 'U'
     and i.fill_factor not in (0, 100)
   -- order by i.fill_factor desc, o.name
)
select i.Database_Name, i.Schema_Name, i.Table_Name, i.type_desc, i.Index_Name, i.Index_Type, i.fill_factor
      ,(sum(s.[used_page_count]) * 8)/1024 as IndexSizeMB
  from index_info i
  join sys.dm_db_partition_stats as s
    on s.[object_id] = i.[object_id]
   and s.[index_id] = i.[index_id]
 group by i.Database_Name, i.Schema_Name, i.Table_Name, i.type_desc, i.Index_Name, i.Index_Type, i.fill_factor
 order by 7 desc