--1 Create a tunning task
DECLARE
 my_task_name VARCHAR2(30);
 my_sqltext   CLOB;
BEGIN
 my_sqltext := 'SELECT /*+ ORDERED */ * '                      ||
               'FROM employees e, locations l, departments d ' ||
               'WHERE e.department_id = d.department_id AND '  ||
                     'l.location_id = d.location_id AND '      ||
                     'e.employee_id < :bnd';

 my_task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK(
         sql_text    => my_sqltext,
         bind_list   => sql_binds(anydata.ConvertNumber(100)),
         user_name   => 'HR',
         scope       => 'COMPREHENSIVE',
         time_limit  => 60,
         task_name   => 'my_sql_tuning_task',
         description => 'Task to tune a query on a specified employee');
END;
/



--1 Create a tunning task (sqlID)
DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 173247,
                          end_snap    => 173248,
                          sql_id      => '19v5guvsgcd1v',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => '19v5guvsgcd1v_AWR_tuning_task',
                          description => 'Tuning task for statement 19v5guvsgcd1v in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/




--Consulta: SELECT task_name FROM DBA_ADVISOR_LOG WHERE owner = 'HR';


--2 Execute the tunning task
BEGIN
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK( task_name => 'my_sql_tuning_task' );
END;
/

--Verifica status da execução:
--SELECT status FROM USER_ADVISOR_TASKS WHERE task_name = 'my_sql_tuning_task';
--SELECT sofar, totalwork FROM V$ADVISOR_PROGRESS WHERE user_name = 'HR' AND task_name = 'my_sql_tuning_task';


--3 Verify the results:
SET LONG 1000
SET LONGCHUNKSIZE 1000
SET LINESIZE 100
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( 'my_sql_tuning_task')
  FROM DUAL;

