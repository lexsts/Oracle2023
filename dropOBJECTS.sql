--APAGA OBJETOS NO DESTINO ANTES DE REALIZAR O RESTORE
select 'drop '||object_type||' '|| owner || '.' || object_name|| DECODE(OBJECT_TYPE,'TABLE',' CASCADE CONSTRAINTS PURGE') || ';'
from dba_objects where object_type in ('TABLE','VIEW','PACKAGE','TYPE','PROCEDURE','FUNCTION','TRIGGER','SEQUENCE') 
and owner in ('PR01RCDO','PR01CHSO','PR02CHSO','PR03CHSO','PR04CHSO');

--EXEMPLO DE RESTORE (ORIGEM: PR01CHSO /  DESTINO: DR01CHSO):
impdp / dumpfile=expdp_RPRTCBRB2_291220_0214_01.dmp,expdp_RPRTCBRB2_291220_0214_02.dmp,expdp_RPRTCBRB2_291220_0214_03.dmp,expdp_RPRTCBRB2_291220_0214_04.dmp,expdp_RPRTCBRB2_291220_0214_05.dmp,expdp_RPRTCBRB2_291220_0214_06.dmp logfile=IMPDP_expdp_RPRTCBRB2_291220_DR01CHSO.log remap_schema=PR01CHSO:DR01CHSO SCHEMAS=PR01CHSO

--RECOMPILA SINONIMOS
select decode (object_type, 'PACKAGE BODY',
       'ALTER PACKAGE ' || OWNER ||'.'|| OBJECT_NAME || ' COMPILE BODY;',
       'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME || ' COMPILE;') as "OBJETOS INVALIDOS"
  from dba_objects
   where status <> 'VALID'
   and object_type in ('PACKAGE BODY', 'PACKAGE', 'FUNCTION','PROCEDURE', 'TRIGGER','VIEW','SYNONYM')
order by object_type;

