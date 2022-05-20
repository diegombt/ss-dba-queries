############################################################################################################
# Utilizar BCP como medio para migrar objetos entre bases de datos
# https://www.tech-recipes.com/rx/71781/how-to-use-bcp-utility-in-sql-server/
############################################################################################################

# Utilizar una consulta y exportar su resultado a un archivo. -C ACP permite que se utilice un collation
# como el Latin sin inconvenientes
BCP "select * from aportes.dbo.tb_apo_devolucion" QUERYOUT  "\\VMPRUARMENIA\i$\QUERYDEV.txt" -T -S VMPRUARMENIA -t "|" -c -C ACP

# Cuando la consulta sea compleja puede utilizarse un SP e invocarlo
BCP "exec aportes.dbo.migrar_tb_APO_PLANILLA_ENCABEZADO" QUERYOUT  "I:\APO_PLANILLA_ENCABEZADO.txt" -T -S VMPRUARMENIA -t "|" -c -C ACP

# Se puede exportar una tabla sin una consulta, con este comando
BCP ADMIN.DBO.tb_APO_DEVOLUCION IN "\\VMPRUARMENIA\i$\QUERYDEV.txt" -T -S VMDTURQUIA -t "|" -c -C ACP


############################################################################################################
# Load data to SQL Server table
BCP from sisfam.dbo.tb_sisfam_log_auditoria" IN "\\vmpjuno\h$\log\querydev.txt" -t "|" -c -C ACP -T -S vcronos