------------------------------------------------------------------------------------------------------------
-- Transar - Validar que se estén registrando los pagos
-- Consulta en la BD LOG del servidor vmppatna
------------------------------------------------------------------------------------------------------------
select top 10 * 
  from [LOG].[dbo].[Log_Aplicacion] a (nolock)
 where proceso = 'SERV_PAGO'
   and fecha_num = cast(convert([varchar](8),getdate(),(112)) as int)
   and fecha > dateadd(minute, -15, getdate())
 order by fecha desc