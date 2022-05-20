/***********************************************************************************************************
 * Statistics - Last update date
 ***********************************************************************************************************/
select sch.name + '.' + so.name as TableName
      ,ss.name as Statistic
      ,sp.last_updated as StatsLastUpdated
      ,sp.rows as RowsInTable
      ,sp.rows_sampled as RowsSampled
      ,sp.modification_counter as RowModifications
      ,(sp.rows_sampled * 100)/sp.rows as SamplePercent
  from sys.stats ss
  join sys.objects so
    on ss.object_id = so.object_id
  join sys.schemas sch
    on so.schema_id = sch.schema_id
 outer APPLY sys.dm_db_stats_properties(so.object_id, ss.stats_id) sp
 where so.type = 'U'
   and sp.modification_counter > 0 --change accordingly
    -- and (sp.rows_sampled * 100)/sp.rows <= 100
 order by sp.last_updated desc;