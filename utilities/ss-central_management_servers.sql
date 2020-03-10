------------------------------------------------------------------------------------------------------------
-- Show duplicated servers on Central Management Servers
------------------------------------------------------------------------------------------------------------
use msdb;
go

select distinct o.server_name
      ,g.name
  from (select si.server_name
			  ,count(*) as count
		  from msdb.dbo.sysmanagement_shared_server_groups_internal s
		  join msdb.dbo.sysmanagement_shared_registered_servers_internal si
			on si.server_group_id = s.server_group_id
		 group by si.server_name
		having count(*) > 1
        ) o
  join msdb.dbo.sysmanagement_shared_registered_servers_internal si
    on si.server_name = o.server_name
  join msdb.dbo.sysmanagement_shared_server_groups_internal g
    on g.server_group_id = si.server_group_id
 order by 1, 2;
go
