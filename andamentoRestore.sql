----------------------------------------------------------------------------------------
-- ANDAMENTO DA ATIVIDADE
----------------------------------------------------------------------------------------

  SELECT job_name "Nome",
owner_name "Dono" ,
workers ,
job_mode "Modo" ,
dp.state "Status" ,
ROUND((sofar*100)/totalwork,2) "% Completado"
FROM gv$session_longops sl, gv$datapump_job dp
WHERE sl.opname = dp.job_name
AND sofar != totalwork



--DATAPUMP
SELECT owner_name,
       job_name,
       TRIM(operation) AS operation,
       TRIM(job_mode) AS job_mode,
       state,
       degree,
       attached_sessions,
       datapump_sessions
FROM   dba_datapump_jobs
ORDER BY 1, 2;

--ATTACH JOB
impdp attach=job_name (SELECT OWNER_NAME,JOB_NAME,OPERATION,JOB_MODE,STATE from DBA_DATAPUMP_JOBS;)