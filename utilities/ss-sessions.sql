------------------------------------------------------------------------------------------------------------
-- SQL Server sys.dm_exec_sessions is a server-scope view that shows information about all active user 
-- connections and internal tasks.
-- This query retrieves count of active sessions.
------------------------------------------------------------------------------------------------------------
select count(session_id) as [active sessions]
  from sys.dm_exec_sessions
 where status = 'running'

------------------------------------------------------------------------------------------------------------
-- Kills dormant sessions, for a database list
-- blog.sqlauthority.com/2019/05/06/sql-server-script-to-kill-all-inactive-sessions-kill-sleeping-sessions-from-sp_who2/
------------------------------------------------------------------------------------------------------------
declare @user_spid int
declare curspid cursor fast_forward
for
  with database_list as (
      select database_id from master.sys.databases where name in ('test') -- Add database list for killing sessions
  )
  select distinct spid
    from master.dbo.sysprocesses (nolock)
   where 1=1
     and spid > 50                                                        -- Avoid system threads
     and spid <> @@spid                                                   -- Ignore current spid
     and status = 'sleeping'                                              -- Only sleeping threads
     and dbid in (select database_id from database_list)                  -- Only sessions for selected databases
open curspid
fetch next from curspid into @user_spid
  while (@@fetch_status = 0)
  begin
    print 'killing '+convert(varchar,@user_spid)
    exec('kill '+@user_spid)
    fetch next from curspid into @user_spid
  end
close curspid
deallocate curspid
go