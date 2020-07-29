------------------------------------------------------------------------------------------------------------
-- Suspect Pages
-- https://www.sqlserverscience.com/internals/suspect_pages/
-- https://www.sentryone.com/blog/johnmartin/monitoring-for-suspect-pages
------------------------------------------------------------------------------------------------------------
use msdb;

if object_id(N'tempdb..#suspect_page_events', N'U') is not null
begin
    drop table #suspect_page_events;
end
create table #suspect_page_events (
     event_type int not null primary key clustered
    ,event_description varchar(144) NOT NULL
);
insert into #suspect_page_events (event_type, event_description)
values
  (1, 'An 823 error that causes a suspect page (such as a disk error) or an 824 error other than a bad checksum or a torn page (such as a bad page ID).')
, (2, 'Bad checksum.')
, (3, 'Torn page.')
, (4, 'Restored (page was restored after it was marked bad).')
, (5, 'Repaired (DBCC repaired the page).')
, (7, 'Deallocated by DBCC.');

select d.name as database_name
      ,mf.name as file_name
      ,sp.page_id
      ,spe.event_description as description
      ,sp.error_count
      ,sp.last_update_date as last_update
  from msdb.dbo.suspect_pages sp
  join sys.databases d
    on sp.database_id = d.database_id
  join sys.master_files mf
    on sp.database_id = mf.database_id
   and sp.file_id = mf.file_id
  left join #suspect_page_events spe
    on sp.event_type = spe.event_type
 order by sp.last_update_date desc;