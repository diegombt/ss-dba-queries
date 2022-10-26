------------------------------------------------------------------------------------------------------------
-- transaction statistics per day, hour and minute since the time of the last service restart 
-- http://www.sqlfingers.com/2019/01/this-post-will-help-you-query-your-sql.html
------------------------------------------------------------------------------------------------------------
/* SQL Server transactions per day/hour/minute using sys.dm_os_performance_counters */

-- declarations
declare @Days SMALLINT
       ,@Hours INT
       ,@Minutes BIGINT
       ,@LastRestart DATETIME;

-- get last restart date
select @Days = datediff(d, create_date, getdate()),@LastRestart = create_date
  from sys.databases
 where database_id = 2;

-- collect days/hours since last restart
select @Days = case when @Days = 0 then 1 else @Days end;
select @Hours = @Days * 24;
select @Minutes = @Hours * 60;


-- trans since last restart
select @LastRestart [LastRestart]
      ,@@servername [Instance]
      ,cntr_value [TotalTransSinceLastRestart]
      ,cntr_value / @Days [AvgTransPerDay]
      ,cntr_value / @Hours [AvgTransPerHour]
      ,cntr_value / @Minutes [AvgTransPerMinute]
  from sys.dm_os_performance_counters
 where 1=1
   and counter_name = 'Transactions/sec'
   and instance_name = '_Total';

-- trans since last restart per database
select @LastRestart [LastRestart]
      ,@@servername [Instance]
      ,instance_name [Database_Name]
      ,cntr_value [TotalTransSinceLastRestart]
      ,cntr_value / @Days [AvgTransPerDay]
      ,cntr_value / @Hours  [AvgTransPerHour]
      ,cntr_value / @Minutes [AvgTransPerMinute]
  from sys.dm_os_performance_counters
 where 1=1
   and counter_name = 'Transactions/sec'
   and instance_name <> '_Total'
 order by cntr_value desc;