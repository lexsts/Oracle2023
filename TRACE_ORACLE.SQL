--Cria a tabela de registro dos traces
--drop table SYS.login_audit_info;
CREATE TABLE SYS.AUDIT_INFO_TRACE
(
logon_time timestamp, 
sid NUMBER,
SERIAL NUMBER,
username VARCHAR2(100),
machine VARCHAR2(64),
tracefile VARCHAR2(100)
);

--Concede privilégio nessa tabela para os usuários que serão traceados
grant all on SYS.AUDIT_INFO_TRACE to BDSSA_PORTAL;
grant all on SYS.AUDIT_INFO_TRACE to BDSSA_DW;
grant all on SYS.AUDIT_INFO_TRACE to BDSSA_ETL_WORK;
grant all on SYS.AUDIT_INFO_TRACE to BDSSA_ETL_MASTER;
grant all on SYS.AUDIT_INFO_TRACE to BLADELOGIC;

--Concede privilégio para os usuários executarem "ALTER SESSION"
GRANT ALTER SESSION TO BDSSA_PORTAL;
GRANT ALTER SESSION TO BDSSA_DW;
GRANT ALTER SESSION TO BDSSA_ETL_WORK;
GRANT ALTER SESSION TO BDSSA_ETL_MASTER;
GRANT ALTER SESSION TO BLADELOGIC;

--Cria a trigger de logon 
CREATE OR REPLACE TRIGGER TRACE_LOGON
AFTER LOGON ON DATABASE
DECLARE
  VString varchar2(100);
BEGIN   
    IF USER IN ('PR01FASEQTU') --<Filtrar pelos usuários que serão traceados
  THEN				
                execute immediate 'alter session set tracefile_identifier=TRC_PR01FASEQTU';--<O arquivo gerado terá essa string no nome
                execute immediate 'ALTER SESSION SET sql_trace = true';
				EXECUTE IMMEDIATE 'alter session set events ''10046 trace name context forever, level 12''';				
				SELECT 'TRACE HABILITADO PARA O USUÁRIO: PR01FASEQTU.' INTO VString FROM DUAL; 
                INSERT INTO SYS.AUDIT_INFO_TRACE (logon_time, sid, serial, username, machine, tracefile) select CURRENT_TIMESTAMP,se.sid,se.serial#,se.username,se.machine,tracefile from v$process pro, gv$session se WHERE se.sid = Sys_Context('USERENV', 'SID') and AUDSID = Sys_Context('USERENV', 'SESSIONID') AND pro.addr = se.paddr;
  END IF;
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

--Consulta a tabela
select * from SYS.AUDIT_INFO_TRACE;

--Consulta o status da trigger
select owner,trigger_name,status from dba_triggers where trigger_name='TRACE_LOGON';

#TRACE EVENTOS DE ERRO
--alter system set events '1 trace name errorstack level 3'; 
--alter system set events '1 trace name errorstack off'; 


##Gera TKProf e COMMANDS

 select LOGON_TIME,SID,SERIAL,USERNAME,MACHINE,TRACEFILE,'tkprof '||TRACEFILE||' '||REPLACE(TRACEFILE,'.trc','.txt') || ' sys=no record='||REPLACE(TRACEFILE,'.trc','.cmd') COMMAND_TKPROF_EXTRACT_SQL,'cat '||REPLACE(TRACEFILE,'.trc','.cmd') SEE_COMMAND_SQL
from SYSTEM.AUDIT_INFO_TRACE;
 
  tkprof  cdmg_ora_6088.trc trace.txt sys=no explain=tech4b/dba01dba  --Ignora comandos do SYS
  tkprof RPCORBRA1_ora_23054_TRC_PR01LUMO.trc RPCORBRA1_ora_23054_TRC_PR01LUMO.txt sys=no record=RPCORBRA1_ora_23054_TRC_PR01LUMO_CMDS.txt --Salva os comandos em um arquivo a parte
  tkprof RPCORBRA1_ora_23054_TRC_PR01LUMO.trc RPCORBRA1_ora_23054_TRC_PR01LUMO.txt sys=no INSERT=Inserts.tx --Salva as estatisticas dos comandos em um arquivo a parte
  tkprof SINACOR_ora_111.trc output_gera_xml.txt EXPLAIN=corrwin/john8*doe@sinacor SYS=NO sort=prsela,execpu,exeela,fchcpu,fchela
  
  
  
##FECHA O TRACE

--Após coleta, desabilita a trigger
alter trigger TRACE_LOGON disable;

SPOOL CLOSE_TRACES.SQL
set hea off 
select 'oradebug setospid '||spid|| '
 oradebug close_trace;'  
from v$process p, v$session s
where s.PADDR = p.addr
/
SPOOL OFF
@CLOSE_TRACES.SQL

spool close_trace_dbms_system.sql
SELECT 'EXEC DBMS_SYSTEM.SET_EV('||S.SID||','||S.SERIAL#||','||10046||','||0||','||''''''||');' 
FROM V$SESSION S,V$PROCESS P WHERE S.PADDR=P.ADDR 
/
spool off
@close_trace_dbms_system.sql  