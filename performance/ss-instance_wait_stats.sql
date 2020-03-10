------------------------------------------------------------------------------------------------------------
-- Returns information about all the waits encountered by threads that executed. You can use this aggregated
-- view to diagnose performance issues with SQL Server and also with specific queries and batches.
------------------------------------------------------------------------------------------------------------
-- SQL Server wait information FROM sys.dm_os_wait_stats
-- Copyright (c) 2014, brent ozar unlimited.
-- See http://brentozar.com/GO/eula for the END user licensing agreement.
------------------------------------------------------------------------------------------------------------
-- More info on wait stats
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-wait-stats-transact-sql?view=sql-server-ver15
------------------------------------------------------------------------------------------------------------

/*********************************
let's build a list of waits we can safely ignore.
*********************************/
IF object_id('tempdb..#ignorable_waits') IS NOT NULL
DROP TABLE #ignorable_waits;
GO

CREATE TABLE #ignorable_waits (wait_type NVARCHAR(256) PRIMARY KEY);
GO

/* we aren't using row constructors to be sql 2005 compatible */
SET NOCOUNT ON;
INSERT #ignorable_waits (wait_type) VALUES ('request_for_deadlock_search');
INSERT #ignorable_waits (wait_type) VALUES ('sqltrace_incremental_flush_sleep');
INSERT #ignorable_waits (wait_type) VALUES ('sqltrace_buffer_flush');
INSERT #ignorable_waits (wait_type) VALUES ('lazywriter_sleep');
INSERT #ignorable_waits (wait_type) VALUES ('xe_timer_event');
INSERT #ignorable_waits (wait_type) VALUES ('xe_dispatcher_wait');
INSERT #ignorable_waits (wait_type) VALUES ('ft_ifts_scheduler_idle_wait');
INSERT #ignorable_waits (wait_type) VALUES ('logmgr_queue');
INSERT #ignorable_waits (wait_type) VALUES ('checkpoint_queue');
INSERT #ignorable_waits (wait_type) VALUES ('broker_to_flush');
INSERT #ignorable_waits (wait_type) VALUES ('broker_task_stop');
INSERT #ignorable_waits (wait_type) VALUES ('broker_eventhandler');
INSERT #ignorable_waits (wait_type) VALUES ('sleep_task');
INSERT #ignorable_waits (wait_type) VALUES ('waitfor');
INSERT #ignorable_waits (wait_type) VALUES ('dbmirror_dbm_mutex')
INSERT #ignorable_waits (wait_type) VALUES ('dbmirror_events_queue')
INSERT #ignorable_waits (wait_type) VALUES ('dbmirroring_cmd');
INSERT #ignorable_waits (wait_type) VALUES ('dispatcher_queue_semaphore');
INSERT #ignorable_waits (wait_type) VALUES ('broker_receive_waitfor');
INSERT #ignorable_waits (wait_type) VALUES ('clr_auto_event');
INSERT #ignorable_waits (wait_type) VALUES ('dirty_page_poll');
INSERT #ignorable_waits (wait_type) VALUES ('hadr_filestream_iomgr_iocompletion');
INSERT #ignorable_waits (wait_type) VALUES ('ondemand_task_queue');
INSERT #ignorable_waits (wait_type) VALUES ('ft_iftshc_mutex');
INSERT #ignorable_waits (wait_type) VALUES ('clr_manual_event');
INSERT #ignorable_waits (wait_type) VALUES ('sp_server_diagnostics_sleep');
INSERT #ignorable_waits (wait_type) VALUES ('qds_cleanup_stale_queries_task_main_loop_sleep');
INSERT #ignorable_waits (wait_type) VALUES ('qds_persist_task_main_loop_sleep');

INSERT #ignorable_waits (wait_type) VALUES ('broker_transmitter');
INSERT #ignorable_waits (wait_type) VALUES ('hadr_work_queue');
INSERT #ignorable_waits (wait_type) VALUES ('hadr_notification_dequeue');
INSERT #ignorable_waits (wait_type) VALUES ('hadr_clusapi_call');
INSERT #ignorable_waits (wait_type) VALUES ('hadr_timer_task');
INSERT #ignorable_waits (wait_type) VALUES ('hadr_sync_commit');
INSERT #ignorable_waits (wait_type) VALUES ('qds_async_queue');
INSERT #ignorable_waits (wait_type) VALUES ('preemptive_sp_server_diagnostics');

GO

/* want to manually exclude an event and recalculate?*/
/* INSERT #ignorable_waits (wait_type) VALUES (''); */

------------------------------------------------------------------------------------------------------
-- What are the highest overall waits since startup?
------------------------------------------------------------------------------------------------------
SELECT TOP 25
       os.wait_type,
       SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
       CAST(100.* SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) / (1. * SUM(os.wait_time_ms) over ()) AS NUMERIC(12,1)) AS pct_wait_time,
       SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks,
       CASE WHEN SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) > 0 
                 THEN CAST(SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) / 
                 (1. * SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type)) AS NUMERIC(12,1))
            ELSE 0
       END AS avg_wait_time_ms,
       CURRENT_TIMESTAMP AS sample_time
  FROM sys.dm_os_wait_stats os
  LEFT JOIN #ignorable_waits iw ON os.wait_type=iw.wait_type
 WHERE iw.wait_type IS NULL
 ORDER BY sum_wait_time_ms DESC;
GO

------------------------------------------------------------------------------------------------------
-- What are the higest waits *right now*?
------------------------------------------------------------------------------------------------------

/* note: this is dependent ON the #ignorable_waits table created earlier. */
IF object_id('tempdb..#wait_batches') IS NOT NULL
DROP TABLE #wait_batches;
IF object_id('tempdb..#wait_data') IS NOT NULL
DROP TABLE #wait_data;
GO

CREATE TABLE #wait_batches (
    batch_id INT IDENTITY PRIMARY KEY,
    sample_time DATETIME NOT NULL
);

CREATE TABLE #wait_data ( 
    batch_id INT NOT NULL ,
    wait_type NVARCHAR(256) NOT NULL ,
    wait_time_ms BIGINT NOT NULL ,
    waiting_tasks BIGINT NOT NULL
);
GO

CREATE CLUSTERED INDEX cx_wait_data ON #wait_data(batch_id);
GO

------------------------------------------------------------------------------------------------------
-- This temporary procedure records wait data to a temp table.
------------------------------------------------------------------------------------------------------
IF object_id('tempdb..#get_wait_data') IS NOT NULL
DROP PROCEDURE #get_wait_data;
GO

CREATE PROCEDURE #get_wait_data
    @intervals tinyint = 2,
    @delay CHAR(12)='00:00:30.000' /* 30 seconds*/
AS
    DECLARE @batch_id INT;
    DECLARE @current_interval TINYINT;
    DECLARE @msg NVARCHAR(max);

    SET nocount ON;
    SET @current_interval=1;

    WHILE @current_interval <= @intervals
    BEGIN
        INSERT #wait_batches(sample_time)
        SELECT CURRENT_TIMESTAMP;

        SELECT @batch_id=scope_IDENTITY();

        INSERT #wait_data (batch_id, wait_type, wait_time_ms, waiting_tasks)
        SELECT @batch_id,
               os.wait_type,
               SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
               SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
          FROM sys.dm_os_wait_stats os
          LEFT JOIN #ignorable_waits iw ON (os.wait_type=iw.wait_type)
         WHERE iw.wait_type IS NULL
         ORDER BY sum_wait_time_ms DESC;

        SET @msg = CONVERT(CHAR(23), CURRENT_TIMESTAMP, 121) + N': completed sample '
                 + CAST(@current_interval AS NVARCHAR(4))
                 + N' of '
                 + CAST(@intervals AS NVARCHAR(4))
                 + '.'
        RAISERROR (@msg, 0, 1) WITH NOWAIT;

        SET @current_interval = @current_interval+1;

        IF @current_interval <= @intervals
        WAITFOR DELAY @delay;
    END
GO

------------------------------------------------------------------------------------------------------
-- Let's take two samples 30 seconds apart
------------------------------------------------------------------------------------------------------
EXEC #get_wait_data @intervals=2, @delay='00:00:30.000';
GO

------------------------------------------------------------------------------------------------------
-- What were we waiting on?
-- This query compares the most recent two samples.
------------------------------------------------------------------------------------------------------
WITH max_batch AS (
    SELECT TOP 1 batch_id, sample_time
    FROM #wait_batches
    ORDER BY batch_id DESC
)
SELECT b.sample_time AS [second sample time],
       DATEDIFF(ss,wb1.sample_time, b.sample_time) AS [sample duration in seconds],
       wd1.wait_type,
       CAST((wd2.wait_time_ms-wd1.wait_time_ms)/1000. AS NUMERIC(12,1)) AS [wait time (seconds)],
       (wd2.waiting_tasks-wd1.waiting_tasks) AS [number of waits],
       CASE WHEN (wd2.waiting_tasks-wd1.waiting_tasks) > 0 
                 THEN CAST((wd2.wait_time_ms-wd1.wait_time_ms)/(1.0*(wd2.waiting_tasks-wd1.waiting_tasks)) AS NUMERIC(12,1))
            ELSE 0 
       END AS [avg ms per wait]
  FROM max_batch b
  JOIN #wait_data wd2 ON (wd2.batch_id=b.batch_id)
  JOIN #wait_data wd1 ON (wd1.wait_type=wd2.wait_type and wd2.batch_id - 1 = wd1.batch_id)
  JOIN #wait_batches wb1 ON (wd1.batch_id=wb1.batch_id)
 WHERE (wd2.waiting_tasks-wd1.waiting_tasks) > 0
 ORDER BY [wait time (seconds)] DESC;
GO