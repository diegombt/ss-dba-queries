------------------------------------------------------------------------------------------------------------
-- Collect server info. This queries retrieve SQL Server information
------------------------------------------------------------------------------------------------------------
with server_info as (
  select serverproperty('ServerName') as server_name
        ,serverproperty('MachineName') as machine_name
        ,serverproperty('InstanceName') as instance_name
        ,serverproperty('ProductLevel') as service_pack
        ,@@version as full_version
        ,cast(serverproperty('ProductVersion') as varchar) as compilation
        ,serverproperty('Collation') as collation
        ,serverproperty('Edition') as edition
        ,serverproperty('EngineEdition') as engine_edition
        ,serverproperty('IsClustered') as is_clustered
        ,serverproperty('IsHadrEnabled') as is_hadr_enabled
        ,serverproperty('InstanceDefaultDataPath') as default_data_path
        ,serverproperty('InstanceDefaultLogPath') as default_log_path
        ,serverproperty('LicenseType') as license_type
)
select server_name
      ,machine_name
      ,instance_name
      ,service_pack
      ,case when cast(compilation as varchar) like '9.%' then '2005'
            when cast(compilation as varchar) like '10.0%' then '2008'
            when cast(compilation as varchar) like '10.5%' then '2008R2'
            when cast(compilation as varchar) like '11.%' then '2012'
            when cast(compilation as varchar) like '12.%' then '2014'
            when cast(compilation as varchar) like '13.%' then '2016'
            when cast(compilation as varchar) like '14.%' then '2017'
            when cast(compilation as varchar) like '15.%' then '2019'
            else cast(compilation as varchar) end as version
      ,full_version
      ,compilation
      ,collation
      ,edition
      ,case engine_edition
            when 1 then 'Personal or Desktop Engine'
            when 2 then 'Standard'
            when 3 then 'Enterprise'
            when 4 then 'Express'
            when 5 then 'SQL Database'
            when 6 then 'Azure Synapse Analytics'
            when 8 then 'Managed Instance'
       end as engine_edition
      ,is_clustered
      ,is_hadr_enabled
      ,default_data_path
      ,default_log_path
      ,license_type
  from server_info
 order by left(compilation, charindex('.', compilation)-1), service_pack, edition