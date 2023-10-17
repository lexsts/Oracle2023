rem -----------------------------------------------------------------------
rem Name  : baseline.sql
rem Author: gmonteiro
rem Date  : 07/04/2017
rem Desc  : Mostra baselines criadas no banco
rem -----------------------------------------------------------------------

col PLAN_NAME for a30
col SQL_HANDLE for a20
col CREATOR for a12
col CREATED for a20
col PARSING_SCHEMA_NAME for a20
col SQL_TEXT for a40

PROMPT 
PROMPT ===========================================================================================
PROMPT DBA_SQL_PLAN_BASELINES (MOSTRA AS BASELINES CRIADAS)
PROMPT ===========================================================================================

select creator, sql_handle, plan_name, to_char(CREATED,'DD-MM-YYYY HH24:MI:SS') CREATED, enabled, accepted, executions, substr(sql_text,1,40) as SQL_TEXT
from dba_sql_plan_baselines;


PROMPT ===========================================================================================
PROMPT COMANDO PARA CRIAR BASELINE
PROMPT ===========================================================================================
PROMPT
PROMPT var q number ;
PROMPT exec :q := dbms_spm.load_plans_from_cursor_cache(sql_id => 'sql_id', plan_hash_value => plan_hash_value );
PROMPT
PROMPT ===========================================================================================