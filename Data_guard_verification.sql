--Executar em todos os nodes envolvidos na replicação


Select para checar se a replicação de log está funcionando

SELECT A.SEQUENCE#, 
       A.NAME, 
       A.DEST_ID, 
       A.STANDBY_DEST, 
       A.ARCHIVED, 
       A.APPLIED, 
       A.DELETED, 
       A.COMPLETION_TIME 
  FROM V$ARCHIVED_LOG A 
-- WHERE A.DEST_ID = 2 
ORDER BY A.COMPLETION_TIME DESC; 

