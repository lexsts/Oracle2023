rem -----------------------------------------------------------------------
rem Name  : session_rollback.sql
rem Author: gmonteiro
rem Date  : 21/05/2020
rem Desc  : Mostra sessoes em rollback e tempo restante para uma dada sessao
-- https://www.anbob.com/archives/1727.html
rem -----------------------------------------------------------------------

SET LINESIZE 200

COLUMN username FORMAT A15

SELECT s.username,
       s.sid,
       s.serial#,
       t.used_ublk,
       t.used_urec,
       rs.segment_name,
       r.rssize,
       r.status,
	   case when bitand(flag,power(2,7)) > 0 then 'Rolling Back'
                                          else 'Not Rolling Back'
       end   as "Roll Status"
FROM   v$transaction t,
       v$session s,
       v$rollstat r,
       dba_rollback_segs rs
WHERE  s.saddr = t.ses_addr
AND    t.xidusn = r.usn
AND   rs.segment_id = t.xidusn
ORDER BY t.used_ublk DESC;

PROMPT ===============================================
PROMPT  ENTRE COM O SID PARA CALCULAR O TEMPO RESTANTE
PROMPT ===============================================

SET SERVEROUT ON

PROMPT
accept sid char prompt 'Entre com o sid: '
PROMPT

DECLARE
   l_start      NUMBER;
   l_end        NUMBER;
   l_interval   NUMBER := 30;
   l_sid        NUMBER;
BEGIN
   L_SID := &sid;

   SELECT a.used_ublk
     INTO l_start
     FROM v$transaction a, v$session b
    WHERE a.addr = b.taddr AND sid = L_SID;

   DBMS_LOCK.sleep (l_interval);

   SELECT a.used_ublk
     INTO l_end
     FROM v$transaction a, v$session b
    WHERE a.addr = b.taddr AND sid = L_SID;

   IF NVL (l_start, 0) <> NVL (l_end, 0)
   THEN
      IF NVL (l_start, 0) > NVL (l_end, 0)
      THEN
         DBMS_OUTPUT.put_line 
			(
               'Rolling back ! Time est hours:' || (ROUND ((l_end / (l_start - l_end) * l_interval),2)/60/60)
			);
--            || (ROUND (l_end / (l_start - l_end) * l_interval, 2))/60/60);
--            || ROUND (l_end / (l_start - l_end) * l_interval, 2));			
      ELSIF NVL (l_start, 0) < NVL (l_end, 0)
      THEN
         DBMS_OUTPUT.put_line ('Performing DMLs');
      END IF;
   ELSE
      DBMS_OUTPUT.put_line (
         'Session is waiting for commit or rollback! Can not estimate finish time ');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('No active transaction');
END;
/
