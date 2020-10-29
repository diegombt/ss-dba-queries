USE DBA;
GO

/******************************************************************************
 
 Script by Mark B. at Slack / #BrentOzarUnlimited
 2020 - Oct 28
 Presentation by Brent Ozar - How I Use First Responder Kit

 URLs

 http://FirstResponderKit.org

 https://www.brentozar.com/archive/2016/05/dbcc-checkdb-reports-corruption/
 https://www.brentozar.com/archive/2020/06/updating-statistics-causes-parameter-sniffing/
 https://www.brentozar.com/archive/2018/07/tsql2sday-how-much-plan-cache-history-do-you-have/
 https://www.brentozar.com/archive/2018/05/how-to-create-deadlocks-and-troubleshoot-them/
 https://www.mssqltips.com/sqlservertip/6456/improve-sql-server-extended-events-systemhealth-session/
 
******************************************************************************/


/* ----------------------------------------------------------------------------
   sp_Blitz - SQL Server health check

   https://www.brentozar.com/blitz/
---------------------------------------------------------------------------- */

EXEC dbo.sp_Blitz @CheckServerInfo = 1,
                  @CheckUserDatabaseObjects = 0


EXEC dbo.sp_Blitz @CheckServerInfo = 1,
                  @CheckUserDatabaseObjects = 0,
                  @OutputType = 'markdown';



/* ----------------------------------------------------------------------------
   sp_BlitzFirst - Troubleshoot slow SQL Servers

   https://www.brentozar.com/askbrent/
---------------------------------------------------------------------------- */

EXEC dbo.sp_BlitzFirst;


EXEC dbo.sp_BlitzFirst @OutputDatabaseName = 'DBA',
                       @OutputSchemaName = 'dbo',
                       @OutputTableName = 'BlitzFirst',
                       @OutputTableNameFileStats = 'BlitzFirstFileStats',
                       @OutputTableNameWaitStats = 'BlitzFirstWaitStats',
                       @OutputTableNamePerfmonStats = 'BlitzFirstPerfmonStats',
                       @OutputTableNameBlitzCache = 'BlitzFirstBlitzCache',
                       @ExpertMode = 1,
                       @SinceStartup = 1;


EXEC dbo.sp_BlitzFirst @ExpertMode = 1,
                       @SinceStartup = 1,
                       @AsOf = '2020-10-28 15:03';


EXEC dbo.sp_BlitzFirst @SinceStartup = 1, @OutputType = 'Top10';


/* Top 6 wait types worldwide:

1. CXCONSUMER/CXPACKET/LATCH_EX: 
    * Check CTFP & MAXDOP: BrentOzar.com/go/cxpacket
    * sp_BlitzCache @SortOrder = 'reads'
    * sp_BlitzCache @SortOrder = 'cpu'

2. SOS_SCHEDULER_YIELD
    * sp_BlitzCache @SortOrder = 'cpu'

3. PAGEIOLATCH%
    * sp_BlitzCache @SortOrder = 'reads'

4. RESOURCE_SEMAPHORE
    * sp_BlitzCache @SortOrder = 'memory grant'

5. LCK%
    * sp_BlitzLock
    * sp_BlitzIndex @GetAllDatabases = 1 /* look for "Aggressive Indexes" */

6. WRITELOG
    * sp_BlitzCache @SortOrder = 'writes'
*/



/* ----------------------------------------------------------------------------
   sp_BlitzCache - Find your worst-performing queries

   https://www.brentozar.com/blitzcache/
---------------------------------------------------------------------------- */

EXEC dbo.sp_BlitzCache;


EXEC dbo.sp_BlitzCache @SortOrder = 'cpu', @MinutesBack = 90;


EXEC dbo.sp_BlitzCache @SortOrder = 'executions';


EXEC dbo.sp_BlitzCache @SortOrder = 'cpu', @ExportToExcel = 1;


/* ----------------------------------------------------------------------------
   sp_BlitzIndex - Index sanity test

   https://www.brentozar.com/blitzindex/
-------------------------------------------------------------------------------
-- usage stats → mide el numero veces en los que una consulta fue ejecutada con
   ese indice en el plan sin importar el numero de veces que el operador fue
   usado
-- op Stats → cuenta el numero total de veces que un indice fue usado, no se
   sabe cuando fue reiniciado
-----------------------------------------------------------------------------*/

EXEC dbo.sp_BlitzIndex @GetAllDatabases = 1;


EXEC dbo.sp_BlitzIndex @DatabaseName = 'StackOverflow2010',
                       @SchemaName = 'dbo',
                       @TableName = 'Votes';


EXEC dbo.sp_BlitzIndex @GetAllDatabases = 1,
                       @OutputDatabaseName = 'DBA',
                       @OutputSchemaName = 'dbo',
                       @OutputTableName = 'BlitzIndex',
                       @Mode = 2,
                       @SortOrder = 'size';


EXEC dbo.sp_BlitzIndex @GetAllDatabases = 1, @Mode = 3;


EXEC dbo.sp_BlitzIndex @Mode = 1;


/* ----------------------------------------------------------------------------
   sp_BlitzLock - Troubleshooting deadlocks

   https://www.brentozar.com/archive/2017/12/introducing-sp_blitzlock-troubleshooting-sql-server-deadlocks/
---------------------------------------------------------------------------- */

EXEC dbo.sp_BlitzLock



/* ----------------------------------------------------------------------------
   sp_BlitzWho - What is running right now?
   
   Use for:
    - memory grant issues
    - log to table

   https://www.brentozar.com/first-aid/sp_blitzwho/
---------------------------------------------------------------------------- */

EXEC dbo.sp_BlitzWho


EXEC dbo.sp_BlitzWho @OutputDatabaseName = 'DBA',
                     @OutputSchemaName = 'dbo',
                     @OutputTableName = 'BlitzWho';


EXEC dbo.sp_BlitzWho;
WAITFOR DELAY '00:00:02';
GO 10


/* ----------------------------------------------------------------------------
   sp_WhoIsActive - What is running right now?

   Use for:
    - speed
    - lock information

   http://whoisactive.com/docs/
---------------------------------------------------------------------------- */

EXEC dbo.sp_WhoIsActive @get_transaction_info = 1, @get_outer_command = 1, @get_plans = 1, @get_locks = 1;


/*
Use Dedicated Admin Connection (DAC) during emergencies!
https://www.brentozar.com/archive/2011/08/dedicated-admin-connection-why-want-when-need-how-tell-whos-using/
https://www.sqlshack.com/sql-server-dedicated-admin-connection-dac-how-to-enable-connect-and-use/
*/

/*
Consultant toolkit (on-sale now: 67% off)
https://www.brentozar.com/product/consultant-toolkit/

-- For EU people:
https://gumroad.com/l/ConsultantToolkit/
*/
