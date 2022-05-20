------------------------------------------------------------------------------------------------------------
-- Registrar sesiones cada minuto
------------------------------------------------------------------------------------------------------------
begin transaction 
    insert into temporal
    select *, getdate() as 'datetime'
      --  into temporal
      from (select db_name(dbid) DatabaseName, count(dbid) NumberOfConnections, loginame, hostname, hostprocess
              from sys.sysprocesses WITH (NOLOCK) 
             group by db_name (dbid), loginame, hostname, hostprocess) d
             where DatabaseName = 'SessionStateService_0768aab98528434a8fbb81ae69886dd3';
  waitfor delay '00:01:00';
commit 
go 1000

------------------------------------------------------------------------------------------------------------
-- Extraer información
------------------------------------------------------------------------------------------------------------
select hostname
      ,datepart(hour, datetime) as hour
      ,avg(numberofconnections) avg_numberofconnections
      ,min(numberofconnections) min_numberofconnections
      ,max(numberofconnections) max_numberofconnections
      ,stdev(numberofconnections) stdev_numberofconnections
  from temporal with(nolock)-- order by 6 desc
 where hostname not in ('vmpmogadiscio', 'vmpuagadugu', '') and hostname is not null
 group by hostname, datepart(hour, datetime)
