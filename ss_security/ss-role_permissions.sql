------------------------------------------------------------------------------------------------------------
-- List all permissions for a given role in a database
-- https://dba.stackexchange.com/a/36620/206202
------------------------------------------------------------------------------------------------------------
select distinct rp.name
      ,objecttype = rp.type_desc
      ,permissiontype = pm.class_desc
      ,pm.permission_name
      ,pm.state_desc
      ,objecttype = 
        case when obj.type_desc is null
               or obj.type_desc = 'SYSTEM_TABLE'
             then pm.class_desc
             else obj.type_desc end
      ,s.name as schemaname
      ,[objectname] = isnull(ss.name, object_name(pm.major_id))
  from sys.database_principals rp 
  join sys.database_permissions pm 
    on pm.grantee_principal_id = rp.principal_id 
  left join sys.schemas ss 
    on pm.major_id = ss.schema_id 
  left join sys.objects obj 
    on pm.[major_id] = obj.[object_id] 
  left join sys.schemas s
    on s.schema_id = obj.schema_id
 where rp.type_desc = 'DATABASE_ROLE' 
   and pm.class_desc <> 'DATABASE' 
 order by rp.name, rp.type_desc, pm.class_desc
