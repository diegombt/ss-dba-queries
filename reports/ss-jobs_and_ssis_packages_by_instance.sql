------------------------------------------------------------------------------------------------------------
-- JOBs and SSIS packages by SQL Server instance
------------------------------------------------------------------------------------------------------------
with cte1 as (
  select j.job_id
        ,jobname = j.name
        ,case when j.enabled = 1 then 'true' else 'false' end as job_is_enabled
        ,js.step_id
        ,js.step_name
        ,js.command
        ,case when js.command like '/DTS%' or js.command like '/SQL%' or js.command like '/ISSERVER%' then charindex('\',js.command, charindex('\',js.command) + 1) --'
              when js.command like '/SERVER%' then charindex('"', js.command, charindex(' ',command, charindex(' ',command) + 1) + 1) + 1
              else 0 end as startindex
        ,case when js.command like '/DTS%' or js.command like '/SQL%'  or js.command like '/ISSERVER%'
              then  charindex('"',js.command, charindex('\',js.command, charindex('\',js.command) + 1)) --'
                  - charindex('\',js.command, charindex('\',js.command) + 1) - 1 --'
              when js.command like '/SERVER%' 
                  then  charindex('"',command, charindex('"', js.command, charindex(' ',command, charindex(' ',command) + 1) + 1) + 1)
                      - charindex('"', js.command, charindex(' ',command, charindex(' ',command) + 1) + 1) - 1
              else 0 end as endindex
    from msdb.dbo.sysjobsteps js
    join msdb.dbo.sysjobs j
      on js.job_id = j.job_id
   where js.subsystem = 'SSIS'
)    
select isnull(serverproperty('InstanceName'), 'Default') InstanceName
      ,jobname
      ,job_is_enabled
      ,step_id
      ,step_name
      ,packagefolderpath = 
        case 
            when command like '/DTS%' or command like '/ISSERVER%' then substring(command, startindex, endindex)
            when command like '/SQL%' then '\MSDB' + substring(command, startindex, endindex)
            when command like '/SERVER%' then '\MSDB\' + substring(command, startindex, endindex)
            else null
        end
    , command
  from cte1
 where lower(command) not like '%maintenance%' 
 order by job_id, step_id