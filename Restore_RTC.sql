--EXEMPLO DE RESTORE (ORIGEM: PR01CHSO /  DESTINO: DR01CHSO):
FAÇA A CÓPIA MANUALMENTE DO BACKUP NA ORIGEM (orapos00602p) PARA O DESTINO (orapos00602b).
PARA ISSO, CONECTE-SE NO HOST DESTINO (orapos00602b), DIRETORIO /HOME/ORACLE/EXPORT E REALIZE A CÓPIA:

$ scp orapos00602p:/home/oracle/export/expdp_RPRTCBRB2_291220_0214* .
expdp_RPRTCBRB2_291220_0214_01.dmp.gz                        100% 5006MB  28.5MB/s   02:56
expdp_RPRTCBRB2_291220_0214_02.dmp.gz                        100% 5006MB  28.5MB/s   02:41
expdp_RPRTCBRB2_291220_0214_03.dmp.gz                        100% 5006MB  28.5MB/s   03:10
expdp_RPRTCBRB2_291220_0214_04.dmp.gz                        100% 5006MB  28.5MB/s   03:26
expdp_RPRTCBRB2_291220_0214_05.dmp.gz                        100% 5006MB  28.5MB/s   02:51
expdp_RPRTCBRB2_291220_0214_06.dmp.gz                        100% 5006MB  28.5MB/s   03:33

--DESCOMPACTE OS ARQUIVOS NO DESTINO
nohup gunzip expdp_RPRTCBRB2_291220_0214_01.dmp.gz &
nohup expdp_RPRTCBRB2_291220_0214_02.dmp.gz &
nohup expdp_RPRTCBRB2_291220_0214_03.dmp.gz &
nohup expdp_RPRTCBRB2_291220_0214_04.dmp.gz &
nohup expdp_RPRTCBRB2_291220_0214_05.dmp.gz &
nohup expdp_RPRTCBRB2_291220_0214_06.dmp.gz &


--APAGUE OS OBJETOS NO DESTINO ANTES DE REALIZAR O RESTORE (EXEMPLO DR01CHSO)
select 'drop '||object_type||' '|| owner || '.' || object_name|| DECODE(OBJECT_TYPE,'TABLE',' CASCADE CONSTRAINTS PURGE') || ';'
from dba_objects where object_type in ('TABLE','VIEW','PACKAGE','TYPE','PROCEDURE','FUNCTION','TRIGGER','SEQUENCE') 
and owner in ('DR01RCDO','DR01CHSO','DR02CHSO','DR03CHSO','DR04CHSO');

select 'drop '||object_type||' '|| owner || '.' || object_name|| DECODE(OBJECT_TYPE,'TABLE',' CASCADE CONSTRAINTS PURGE') || ';'
from dba_objects where object_type in ('TABLE','VIEW','PACKAGE','TYPE','PROCEDURE','FUNCTION','TRIGGER','SEQUENCE') 
and owner in ('PR04CHSO');

select 'drop '||object_type||' '|| owner || '.' || object_name|| DECODE(OBJECT_TYPE,'TABLE',' CASCADE CONSTRAINTS PURGE') || ';'
from dba_objects where object_type in ('TABLE','VIEW','PACKAGE','TYPE','PROCEDURE','FUNCTION','TRIGGER','SEQUENCE') 
and owner in ('PR04CSSO');

--select USERNAME,DEFAULT_TABLESPACE from dba_users where username in ('PR01RCDO','PR01CHSO','PR02CHSO','PR03CHSO','PR04CHSO');
USERNAME        DEFAULT_TABLESPACE
--------------- ------------------------------
PR04CHSO        CHS_DATA
PR04CSSO        CSS_DATA
PR02CHSO        CHS_DATA
PR02CSSO        CSS_DATA
DR04CHSO        CHS_DATA
DR01CHSO        CHS_DATA
DR03CHSO        CHS_DATA
DR02CHSO        CHS_DATA
DR01RCDO        RCD_DATA

PR04CHSO        CHS_DATA
PR03CHSO        CHS_DATA
PR02CHSO        CHS_DATA
PR01CHSO        CHS_DATA
PR01RCDO        RCD_DATA


--FAÇA O IMPORT (EXEMPLO ORIGEM: PR01CHSO /  DESTINO: DR01CHSO):

impdp / dumpfile=expdp_RPRTCSPA2_081022_2300_%U.dmp logfile=IMPDP_expdp_RPRTCSPA2_081022_DR01RCDO.log remap_schema=PR01RCDO:DR01RCDO SCHEMAS=PR01RCDO
impdp / dumpfile=expdp_RPRTCSPA2_081022_2300_%U.dmp logfile=IMPDP_expdp_RPRTCSPA2_081022_DR01CHSO.log remap_schema=PR01CHSO:DR01CHSO SCHEMAS=PR01CHSO
impdp / dumpfile=expdp_RPRTCSPA2_081022_2300_%U.dmp logfile=IMPDP_expdp_RPRTCSPA2_081022_DR02CHSO.log remap_schema=PR02CHSO:DR02CHSO SCHEMAS=PR02CHSO
impdp / dumpfile=expdp_RPRTCSPA2_081022_2300_%U.dmp logfile=IMPDP_expdp_RPRTCSPA2_081022_DR03CHSO.log remap_schema=PR03CHSO:DR03CHSO SCHEMAS=PR03CHSO
impdp / dumpfile=expdp_RPRTCSPA2_081022_2300_%U.dmp logfile=IMPDP_expdp_RPRTCSPA2_081022_DR04CHSO.log remap_schema=PR04CHSO:DR04CHSO SCHEMAS=PR04CHSO



nohup gunzip expdp_RPRTCSPA2_220322_0220_01.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_02.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_03.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_04.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_05.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_06.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_07.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_08.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_09.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_09.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_10.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_11.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_12.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_13.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_14.dmp.gz &
nohup gunzip expdp_RPRTCSPA2_220322_0220_15.dmp.gz &

--RECOMPILA SINONIMOS NO DESTINO
select decode (object_type, 'PACKAGE BODY',
       'ALTER PACKAGE ' || OWNER ||'.'|| OBJECT_NAME || ' COMPILE BODY;',
       'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME || ' COMPILE;') as "OBJETOS INVALIDOS"
  from dba_objects
   where status <> 'VALID'
   and object_type in ('PACKAGE BODY', 'PACKAGE', 'FUNCTION','PROCEDURE', 'TRIGGER','VIEW','SYNONYM')
order by object_type;

