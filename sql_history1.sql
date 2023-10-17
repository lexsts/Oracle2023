-- SQL_HISTORY - Histórico de execução de um determinado sql 
-- &1 SQL_ID

--set lines 300
--set pages 100
set longchunksize 30000
set long 30000
col sql_text for a100

col c1 heading 'Inst' format 9999
col c2 heading 'Begin Time' format a18
col c3 heading 'Execs' format 999,999,999
col c4 heading 'CPU Time per Exec' format 999,999,999,999
col c5 heading 'Buffer Gets' format 999,999,999
col c6 heading 'Sorts' format 9,999,999
col c7 heading 'Elapsed Time/Exec.(sec)' format 999G999G990D00000
col c8 heading 'Avg Rows per Exec.' format 999G999G990D00
col c9 heading 'Plan Hash Value'

select sql_text 
from dba_hist_sqltext
where	sql_id = '&1'
/

PROMPT AWR History Execution Stats
PROMPT ===========================

select a.instance_number                                                        c1,
       to_char(BEGIN_INTERVAL_TIME,'DD-MM-YYYY HH24:MI') 			c2, 
       EXECUTIONS_DELTA 				 			c3, 
       CPU_TIME_DELTA/decode(EXECUTIONS_DELTA,0,1,EXECUTIONS_DELTA)             c4,
       BUFFER_GETS_DELTA                                 			c5,
       SORTS_DELTA                                       			c6,
      (ELAPSED_TIME_DELTA/decode(EXECUTIONS_DELTA,0,1,EXECUTIONS_DELTA))/1000000       c7,
       ROWS_PROCESSED_DELTA/decode(EXECUTIONS_DELTA,0,1,EXECUTIONS_DELTA)       c8,
       PLAN_HASH_VALUE c9
from DBA_HIST_SQLSTAT a, DBA_HIST_SNAPSHOT b
where a.snap_id=b.snap_id
and   a.instance_number=b.instance_number
and sql_id='&1'
order by a.snap_id,a.instance_number;

PROMPT Actual Execution Stats
PROMPT ======================

select inst_id                                                        c1,
       EXECUTIONS                                                    c3,
       CPU_TIME/decode(EXECUTIONS,0,1,EXECUTIONS)             c4,
       BUFFER_GETS                                                   c5,
       SORTS                                                         c6,
      (ELAPSED_TIME/decode(EXECUTIONS,0,1,EXECUTIONS))/1000000       c7,
       ROWS_PROCESSED/decode(EXECUTIONS,0,1,EXECUTIONS)       c8,
       PLAN_HASH_VALUE c9
from GV$SQLSTATS
where sql_id='&1'
order by sql_id
;
