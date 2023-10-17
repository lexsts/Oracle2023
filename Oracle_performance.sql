
--1 Create a tunning task (sqlID)
-- select * from DBA_HIST_SNAPSHOT where END_INTERVAL_TIME>SYSDATE-1 ORDER BY SNAP_ID desc
DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 174542,
                          end_snap    => 174545,
                          sql_id      => 'gz7jc14kg3839',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 300,
                          task_name   => 'gz7jc14kg3839_AWR2_tuning_task',
                          description => 'Tuning task for statement gz7jc14kg3839 in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/


--2 Execute the tunning task
BEGIN
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK( task_name => 'gz7jc14kg3839_AWR2_tuning_task' );
END;
/

--Verifica status da execução:
--SELECT status FROM USER_ADVISOR_TASKS WHERE task_name = 'my_sql_tuning_task';
--SELECT sofar, totalwork FROM V$ADVISOR_PROGRESS WHERE user_name = 'HR' AND task_name = 'my_sql_tuning_task';


--3 Verify the results:
SET LONG 1000
SET LONGCHUNKSIZE 1000
SET LINESIZE 100
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( 'd8ubk841fmn19_AWR_tuning_task')
  FROM DUAL;   
