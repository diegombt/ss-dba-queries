------------------------------------------------------------------------------------------------------------
-- SQL Server sys.dm_exec_sessions is a server-scope view that shows information about all active user 
-- connections and internal tasks.
-- This query retrieves count of active sessions.
------------------------------------------------------------------------------------------------------------
select count(session_id) as [active sessions]
  from sys.dm_exec_sessions
 where status = 'running'