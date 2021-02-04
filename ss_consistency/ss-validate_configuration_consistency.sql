/*
 * This queries are designed to execute massively, may be through SQL Server Central Management Servers
 * for a fast information retrieval. Doesn't support SQL server 2005
 */

/***********************************************************************************************************
 * SQL Server version without support
 ***********************************************************************************************************/
declare @ProductVersion nvarchar(128)
       ,@ProductVersionMajor decimal(10,2)
       ,@ProductVersionMinor decimal(10,2)

   set @ProductVersion = cast(SERVERPROPERTY('ProductVersion') as nvarchar(128));

select @ProductVersionMajor = substring(@ProductVersion, 1, charindex('.', @ProductVersion) + 1)
      ,@ProductVersionMinor = parsename(convert(varchar(32), @ProductVersion), 2);

/***********************************************************************************************************/
if (@ProductVersionMajor = 15 and @ProductVersionMinor < 2000) or
   (@ProductVersionMajor = 14 and @ProductVersionMinor < 1000) or
   (@ProductVersionMajor = 13 and @ProductVersionMinor < 5026) or
   (@ProductVersionMajor = 12 and @ProductVersionMinor < 6024) or
   (@ProductVersionMajor = 11 and @ProductVersionMinor < 7001) or
   (@ProductVersionMajor = 10.5 /*AND @ProductVersionMinor < 6000*/) or
   (@ProductVersionMajor = 10 /*AND @ProductVersionMinor < 6000*/) or
   (@ProductVersionMajor = 9 /*AND @ProductVersionMinor <= 5000*/)
begin
    select 'Version ' + cast(@ProductVersionMajor as varchar(100)) + 
            case when @ProductVersionMajor >= 11 then
            '.' + cast(@ProductVersionMinor as varchar(100)) + ' is no longer supported by Microsoft. You need to apply a service pack.'
            else ' is no longer supported by Microsoft. You should be making plans to upgrade to a modern version of SQL Server.' end as 'Finding'
          ,cast(serverproperty('ProductVersion') as varchar) as version
end

/***********************************************************************************************************
 * Dangerous Build of SQL Server (Corruption/Security)
 ***********************************************************************************************************/

/***** declare variables *****/

if (@ProductVersionMajor = 11 and @ProductVersionMinor >= 3000 and @ProductVersionMinor <= 3436) or
   (@ProductVersionMajor = 11 and @ProductVersionMinor = 5058) or
   (@ProductVersionMajor = 12 and @ProductVersionMinor >= 2000 and @ProductVersionMinor <= 2342)

    select 'Dangerous Build (Corruption): There are dangerous known bugs with version ' + cast(@ProductVersionMajor as varchar(100)) + '.' + cast(@ProductVersionMinor as varchar(100)) as Finding;
else
    select '1' as Finding;

/* Reliability - Dangerous Build of SQL Server (Security) */
if (@ProductVersionMajor = 10 and @ProductVersionMinor >= 5500 and @ProductVersionMinor <= 5512) or
   (@ProductVersionMajor = 10 and @ProductVersionMinor >= 5750 and @ProductVersionMinor <= 5867) or
   (@ProductVersionMajor = 10.5 and @ProductVersionMinor >= 4000 and @ProductVersionMinor <= 4017) or
   (@ProductVersionMajor = 10.5 and @ProductVersionMinor >= 4251 and @ProductVersionMinor <= 4319) or
   (@ProductVersionMajor = 11 and @ProductVersionMinor >= 3000 and @ProductVersionMinor <= 3129) or
   (@ProductVersionMajor = 11 and @ProductVersionMinor >= 3300 and @ProductVersionMinor <= 3447) or
   (@ProductVersionMajor = 12 and @ProductVersionMinor >= 2000 and @ProductVersionMinor <= 2253) or
   (@ProductVersionMajor = 12 and @ProductVersionMinor >= 2300 and @ProductVersionMinor <= 2370)

    select 'Dangerous Build (Security): There are dangerous known bugs with version ' + cast(@ProductVersionMajor as varchar(100)) + '.' + cast(@ProductVersionMinor as varchar(100)) as Finding;
else
    select '1' as Finding;

/***********************************************************************************************************
 * CPU Schedulers Offline
 ***********************************************************************************************************/
declare @Debug tinyint;
    set @Debug = 0;

if exists (select 1 from sys.dm_os_schedulers where is_online = 0)
    select 'CPU Schedulers Offline: https://BrentOzar.com/go/schedulers' as Finding
else
    select '0' as Finding