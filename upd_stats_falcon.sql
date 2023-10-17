rem -----------------------------------------------------------------------
rem Name  : upd_stats_falcon.sql
rem Author: gmonteiro
rem Date  : 30/06/2023
rem Desc  : Atualiza as estatisticas das tabelas TERMO_HISTORY e TRADES do Falcon
rem -----------------------------------------------------------------------

set lines 120
col OWNER for a30
col TABLE_NAME for a30

select owner, table_name, to_char(LAST_ANALYZED,'DD-MM-YYYY HH24:MI:SS') as LAST_ANALYZE from dba_tables WHERE table_name in ('TERMO_HISTORY', 'TRADES') order by 1;

  BEGIN
    FOR c_table IN (SELECT owner, table_name FROM dba_tables WHERE table_name in ('TERMO_HISTORY', 'TRADES'))
    LOOP
      dbms_stats.gather_table_stats(OWNNAME=> c_table.owner, TABNAME=> c_table.table_name, DEGREE=> 8, CASCADE=> TRUE, estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt=>'FOR ALL COLUMNS SIZE AUTO');
    END LOOP;
  END;
  /
  
select owner, table_name, to_char(LAST_ANALYZED,'DD-MM-YYYY HH24:MI:SS') as LAST_ANALYZE from dba_tables WHERE table_name in ('TERMO_HISTORY', 'TRADES') order by 1;

--EXIT