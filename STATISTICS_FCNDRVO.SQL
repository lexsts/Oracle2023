--6ccgqg7mkvgj3
--SPFCNSPB_oratrd51002p
--SPFCNSPJ_oratrd51006p
execute dbms_stats.gather_index_stats(ownname => 'PR03FCNDRVO', indname=> 'ORDHIST_PK_IX', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
execute dbms_stats.gather_index_stats(ownname => 'PR06FCNDRVO', indname=> 'ORDHIST_PK_IX', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR03FCNDRVO',TABNAME=>'order_history',DEGREE => 32);
EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR03FCNDRVO',TABNAME=>'orders',DEGREE => 32);   
EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR06FCNDRVO',TABNAME=>'order_history',DEGREE => 32);
EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR06FCNDRVO',TABNAME=>'orders',DEGREE => 32);


CREATE OR REPLACE PROCEDURE SYS.PROC_STATISTICS_FCNDRVO IS
BEGIN
--Remove o plano de execução do dia anterior na instrução IN abaixo:
Declare 
Cursor Cur_SQLIDs Is
      select address||','||hash_value as HASH from gv$sqlarea where sql_id IN ('6ccgqg7mkvgj3');
      SQLIDs Cur_SQLIDs%ROWTYPE;
Begin
    OPEN Cur_SQLIDs;   
    LOOP
        FETCH Cur_SQLIDs INTO SQLIDs;
        dbms_shared_pool.purge(''||SQLIDs.HASH||'','C',1);
        EXIT WHEN Cur_SQLIDs%NOTFOUND;        
    END LOOP;    
    CLOSE Cur_SQLIDs;
End;
							--Atualiza as estatisticas das tabelas/indices
								dbms_stats.gather_index_stats(ownname => 'PR03FCNDRVO', indname=> 'ORDHIST_PK_IX', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'PR06FCNDRVO', indname=> 'ORDHIST_PK_IX', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
								DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR03FCNDRVO',TABNAME=>'order_history',DEGREE => 32);
								DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR03FCNDRVO',TABNAME=>'orders',DEGREE => 32);   
								DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR06FCNDRVO',TABNAME=>'order_history',DEGREE => 32);
								DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'PR06FCNDRVO',TABNAME=>'orders',DEGREE => 32);
								EXCEPTION
								WHEN OTHERS THEN								
								raise_application_error (-20002,'Ocorreu um erro. Execute o bloco manualmente para identifica-lo.');
END;    
/    

BEGIN
DBMS_SCHEDULER.DROP_JOB ('STATISTICS_CONCILIACAO');
END;
/

BEGIN
 DBMS_SCHEDULER.CREATE_JOB (
   job_name            =>  'STATISTICS_FCNDRVO', 
   job_type            =>  'STORED_PROCEDURE',
   job_action          =>  'SYS.PROC_STATISTICS_FCNDRVO',
   start_date          =>  '23-AUG-21 07:00:00 AM',
   repeat_interval     =>  'FREQ=WEEKLY;BYHOUR=7;BYDAY=SUN',
   enabled              =>  TRUE,
   comments            =>  'Job de estatísticas - Domingo as 07:00hrs - Jobs: PR03FCNDRVO e PR06FCNDRVO');
END;
/