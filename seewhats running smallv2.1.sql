select der.blocking_session_id as blking_spid
,der.session_id as spid
,der.status
--,des.deadlock_priority
,der.wait_type
,der.wait_time 
,der.total_elapsed_time  
,der.cpu_time as cpu_tm
,der.writes
,der.reads 
,der.logical_reads as L_reads
,der.Command
,der.row_count
,der.percent_complete as '%complete'  
,db_name(der.database_id) as dbname      
,SUBSTRING(SQLText.text, statement_start_offset/2 + 1,2147483647) as query
,object_name(SQLText.objectid,der.database_id) as object_name     
,des.host_name as c_host
,dec.client_net_address as c_ip	    
,des.program_name
,des.login_name
,dec.auth_scheme
,dec.net_packet_size as packetsize
,dec.net_transport
,der.plan_handle
--,SQLPlan.query_plan
,deqmg.used_memory_kb
from sys.dm_exec_requests der join sys.dm_exec_sessions des
on (der.session_id = des.session_id) join sys.dm_exec_connections dec
on (des.session_id = dec.session_id) left outer join sys.dm_exec_query_memory_grants deqmg
on (der.session_id = deqmg.session_id) 
cross apply sys.dm_exec_sql_text(der.sql_handle) as SQLText
cross apply sys.dm_exec_query_plan(der.plan_handle) as SQLPlan
where der.session_id > 50
and der.session_id <> @@SPID
order by der.total_elapsed_time desc







get-vm -Name vmpmanizales | select -ExpandProperty networkadapters | select vmname, macaddress, switchname, ipaddresses