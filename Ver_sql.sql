--KILL RAC Vrill#33
SELECT status,to_char(logon_time,'dd/mm/yy hh24:mi') logon,'ALTER SYSTEM KILL SESSION '''||SID||','||SERIAL#||',@'||inst_id||''' IMMEDIATE;' FROM GV$SESSION WHERE username='CTMUSER';
SELECT inst_id,SID,SERIAL#,PROGRAM,LOGON_TIME,'ALTER SYSTEM KILL SESSION '''||SID||','||SERIAL#||',@'||inst_id||''' IMMEDIATE;' FROM GV$SESSION WHERE UPPER(PROGRAM) LIKE '%BDS%'
SELECT SID,SERIAL#,PROGRAM,USERNAME,OSUSER FROM GV$SESSION WHERE STATUS='ACTIVE' and USER NOT IN ('SYS','SYSTEM')and UPPER(PROGRAM) LIKE '%HANDLER%'
--QUERY EXECUTION PLAN
select * from v$sql_plan where sql_id = '2550780989'; --SQL_ID
select * from table(dbms_xplan.display_cursor('52819100')); --HASH_VALUE
--QUERY SQL_ID
SELECT * FROM V$SQLAREA WHERE sql_text like 'SELECT app_id, stream%';
SELECT SQL_FULLTEXT FROM V$SQL WHERE SQL_ID='608kamdkf7rc1'
--PROCESSORS AVAILABLE
select scheduler_id, cpu_id, status, is_online 
from sys.dm_os_schedulers 
where status = 'VISIBLE ONLINE'

--ACTUAL EXECUTION
--ACTUAL EXECUTION
SELECT sesion.sql_id,sesion.sid,
       sesion.serial#,
       sesion.username,
       status,
       to_char(sesion.logon_time,'dd/mm/yy hh24:mi:ss') LOGON_TIME,
       sesion.last_call_et,sesion.PQ_STATUS,sesion.EVENT,sesion.WAIT_CLASS,sesion.SECONDS_IN_WAIT,
       sql_text,
       optimizer_mode,
       hash_value,
       address--,
       --cpu_time / 1000000 "cpu_time (s)",
       --elapsed_time / 1000000 "elapsed_time (s)"
  FROM gv$sqlarea sqlarea, gv$session sesion
 WHERE sesion.sql_hash_value = sqlarea.hash_value   
   AND sesion.sql_address    = sqlarea.address
   AND sesion.STATUS='ACTIVE'
   and sesion.username not in ('GESTAOAMBIENTEORACLE')
   --and  to_char(sesion.logon_time,'dd/mm/yy hh24:mi:ss') between '29/11/22 01:10:18' and '29/11/22 01:10:21'
   --and sesion.sql_id='ca3dmwjmsawhy'--fnf1jbw1x6zhx
   ORDER BY logon_time DESC

--GG
select inst_id,
       sample_time,
       session_id,
       wait_time,
       time_waited/1000000,
       event,
       b.username,
       sql_id,
       session_state,
       blocking_session,
       wait_class,
       c.object_name,
       current_file#,
       current_block#,
       program,
       session_type,
       p1,
       p1text,
       p2,
       p2text,
       p3,
       p3text
  from gv$active_session_history a, dba_users b, dba_objects c
where a.USER_ID = b.user_id(+)
   and a.CURRENT_OBJ# = c.object_id(+)
   and b.username like 'PR01EBDRV%'
   and sample_time between
       to_date('25-09-2022 17:39:00', 'DD-MM-YYYY HH24:MI:SS') and
       to_date('25-09-2022 18:59:00', 'DD-MM-YYYY HH24:MI:SS')
--    and time_waited > 10000
--    and   session_id = 505
--and event like 'log file sync'
--      and time_waited/1000000 > 1
order by sample_time;
   

--Objects and SQL_IDS in sessions
select round(sofar / totalwork * 100, 2) percent_completed,t.*
 from v$session_longops t
 where sofar > 0
 and totalwork > 0
 order by 10 desc
 
--session downgraded parallelism   
   SELECT a.sql_id,a.sid parent_sid,
       to_char(a.logon_time,'dd/mm/yy hh24:mi') logon_time,
       a.program,
       a.osuser,
       a.username,       
       ps.req_degree,
       ps.got_degree
  FROM (SELECT s.sid,
               s.osuser,
               s.USERNAME,
               s.status,
               s.sql_id,
               s.logon_time,
               s.last_call_et,
               UPPER(s.program) program
          FROM v$session s
         WHERE ((s.username IS NOT NULL) AND (NVL(s.osuser, 'x') <> 'SYSTEM') AND
               (s.TYPE <> 'BACKGROUND'))) a
  JOIN (SELECT DISTINCT qcsid,
                        CASE
                            WHEN req_degree > degree THEN
                             1
                            ELSE
                             0
                        END is_downgrade,
                        MAX(req_degree) req_degree,
                        MAX(degree) got_degree
          FROM v$px_session
         GROUP BY qcsid,
                  CASE
                      WHEN req_degree > degree THEN
                       1
                      ELSE
                       0
                  END) ps ON a.sid = ps.qcsid
 WHERE ps.is_downgrade = 1  

--session downgraded parallelism to serial
SELECT sql_id,sess.sid parent_sid,
          to_char(logon_time,'dd/mm/yy hh24:mi') logon_time,
         sess.program,
         sess.osuser,
         sess.username,         
         TRUNC (last_call_et / 60) dur_minutes
  FROM v$sesstat sesstat, v$sysstat sysstat, v$session sess
 WHERE    sesstat.statistic# = sysstat.statistic#
         AND sesstat.sid = sess.sid
         AND name = 'Parallel operations downgraded to serial'
         AND sesstat.VALUE > 0
         AND sess.status = 'ACTIVE' 
   
--LOCKS
SELECT
    SQL_ID,
    sid,
    serial#,
    status,
    username,
    --osuser,
    --program,
    blocking_session blocking, event from v$session
WHERE
    blocking_session IS NOT NULL;
SELECT sesion.sql_id,sesion.sid,
       sesion.serial#,
       sesion.username,
       status,
       to_char(sesion.logon_time,'dd/mm/yy hh24:mi') LOGON_TIME,
       sesion.last_call_et,
       sql_text,
       optimizer_mode,
       hash_value,
       address--,
       --cpu_time / 1000000 "cpu_time (s)",
       --elapsed_time / 1000000 "elapsed_time (s)"
  FROM gv$sqlarea sqlarea, gv$session sesion
 WHERE sesion.sql_hash_value = sqlarea.hash_value   
   AND sesion.sql_address    = sqlarea.address
   AND sesion.STATUS='ACTIVE'
   and sesion.username not in ('ALEXSANTOS')
   and (sid in (SELECT    sid from v$session WHERE    blocking_session IS NOT NULL AND SQL_ID='2y12wa43pjnpb')
   or sid in (SELECT    blocking_session blocking from v$session WHERE blocking_session IS NOT NULL AND SQL_ID='2y12wa43pjnpb'));
   
--LOCK CURSOR
  select s.inst_id as inst,
       s.sid as blocked_sid, 
       s.username as blocked_user,
       sa.sql_id as blocked_sql_id,
       trunc(s.p2/4294967296) as blocking_sid,
       b.username as blocking_user,
       b.sql_id as blocking_sql_id,
       s.event
from gv$session s
join gv$sqlarea sa
  on sa.hash_value = s.p1
join gv$session b
  on trunc(s.p2/4294967296)=b.sid
 and s.inst_id=b.inst_id
join gv$sqlarea sa2
  on b.sql_id=sa2.sql_id
--where s.event='cursor: pin S';
   
	
 --RECURSO OCUPADO
SELECT timestamp,o.owner || '.' ||  o.object_name object,
   o.object_type,
 DECODE(l.locked_mode, 0, 'NONE'
           ,  1, '1 - Null'
           ,  2, '2 - Row Share Lock'
           ,  3, '3 - Row Exclusive Table Lock.'
           ,  4, '4 - Share Table Lock'
           ,  5, '5 - Share Row Exclusive Table Lock.'
           ,  6, '6 - Exclusive Table Lock'
           ,  locked_mode, ltrim(to_char(locked_mode,'990'))) lock_mode,
S.SID, S.SERIAL#, S.STATUS,P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.PORT , S.LOGON_TIME,SQ.SQL_FULLTEXT 
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS
and l.object_id=322298 --OBJECT_ID BLOQUEADO
--and UPPER(SQ.SQL_FULLTEXT) like '%GRP_INFO_PARTICIPANTE_ENVIADA%';

select s.sid
      ,s.serial#
      ,s.username
      ,s.machine
      ,s.status
      ,s.lockwait
      ,t.used_ublk
      ,t.used_urec
      ,t.start_time
      ,to_char(s.logon_time,'dd/mm/yy hh24:mi') LOGON_TIME
from v$transaction t
inner join v$session s on t.addr = s.taddr;

SELECT s.sid,s.username,to_char(s.logon_time,'dd/mm/yy hh24:mi') LOGON_TIME,s.sql_id,t.start_scnw,t.start_scnb,t.start_time,s.username, o.object_name,o.owner 
FROM gv$transaction t, gv$session s, gv$locked_object l,dba_objects o
WHERE l.object_id IN (872352,320996) 
AND t.ses_addr = s.saddr 
AND t.xidusn = l.xidusn 
AND t.xidslot = l.xidslot 
AND t.xidsqn = l.xidsqn 
AND l.object_id = o.object_id;

--TRANSAÇÃO EM ABERTO
SELECT S.SID,S.SERIAL#,S.USERNAME,s.machine,s.program,TO_CHAR(S.LOGON_TIME,'DD/MM/YY HH24:MI') LOGON_TIME,t.start_scnw,t.start_scnb,t.start_time,s.username, o.object_name,o.owner 
FROM gv$transaction t, gv$session s, gv$locked_object l,dba_objects o
WHERE l.object_id IN (322298) --OBJECT_IDS
AND t.ses_addr = s.saddr AND t.xidusn = l.xidusn AND t.xidslot = l.xidslot AND t.xidsqn = l.xidsqn AND l.object_id = o.object_id

 SELECT S.SID
  ,S.SERIAL#
  ,S.USERNAME
  ,S.OSUSER 
  ,S.PROGRAM 
  ,S.EVENT
  ,TO_CHAR(S.LOGON_TIME,'YYYY-MM-DD HH24:MI:SS') 
  ,TO_CHAR(T.START_DATE,'YYYY-MM-DD HH24:MI:SS') 
  ,S.LAST_CALL_ET 
  ,S.BLOCKING_SESSION 
  ,S.STATUS
  ,( 
    SELECT Q.SQL_TEXT 
    FROM V$SQL Q 
    WHERE Q.LAST_ACTIVE_TIME=T.START_DATE 
    AND ROWNUM<=1) AS SQL_TEXT 
FROM V$SESSION S, 
  V$TRANSACTION T 
WHERE S.SADDR = T.SES_ADDR;


--CHECK UNDO BLOCKS
SELECT s.username,
       s.sid,
       s.serial#,
       t.used_ublk,
       t.used_urec,
       rs.segment_name,
       r.rssize,
       r.status,
       s.SQL_ID,
       s.LOGON_TIME
FROM   v$transaction t,
       v$session s,
       v$rollstat r,
       dba_rollback_segs rs
WHERE  s.saddr = t.ses_addr
AND    t.xidusn = r.usn
AND    rs.segment_id = t.xidusn
AND    S.SID IN (
SELECT sesion.sid
  FROM gv$sqlarea sqlarea, gv$session sesion
 WHERE sesion.sql_hash_value = sqlarea.hash_value   
   AND sesion.sql_address    = sqlarea.address
   AND sesion.STATUS='ACTIVE'
   and sesion.username not in ('GESTAOAMBIENTEORACLE')
   and sesion.sql_id='3dm2vbrk6wrws')
ORDER BY t.used_ublk DESC;

select
   c.owner || '.' ||  c.object_name object,
   c.object_type,
   DECODE(a.locked_mode, 0, 'NONE'
           ,  1, '1 - Null'
           ,  2, '2 - Row Share Lock'
           ,  3, '3 - Row Exclusive Table Lock.'
           ,  4, '4 - Share Table Lock'
           ,  5, '5 - Share Row Exclusive Table Lock.'
           ,  6, '6 - Exclusive Table Lock'
           ,  locked_mode, ltrim(to_char(locked_mode,'990'))) lock_mode,
   b.inst_id as node,
   b.sid,
   b.serial#,
   b.status,
   b.username,
   b.osuser
from
   gv$locked_object a ,
   gv$session b,
   dba_objects c
where b.sid = a.session_id
and   a.object_id = c.object_id
and   a.inst_id=b.inst_id;
 
--LAST EXECUTION
SELECT sesion.sid,
       sesion.serial#,
       sesion.username,
       status,
       to_char(sesion.logon_time,'dd/mm/yy hh24:mi') LOGON_TIME,       
       sql_text,
       optimizer_mode,
       hash_value,
       address--,
       --cpu_time / 1000000 "cpu_time (s)",
       --elapsed_time / 1000000 "elapsed_time (s)"
  FROM gv$sqlarea sqlarea, gv$session sesion
 WHERE sesion.PREV_HASH_VALUE = sqlarea.hash_value      
   AND sesion.SID IN (51);


--History
SELECT INSTANCE_NUMBER,
 SESSION_ID,
 SAMPLE_TIME, --05/07/15 23:22:00,324000000
 SQL_ID, 
 SQL_PLAN_HASH_VALUE, 
 WAIT_CLASS, 
 WAIT_TIME,
 TIME_WAITED
 FROM DBA_HIST_ACTIVE_SESS_HISTORY
 WHERE SAMPLE_TIME > '28/07/15 14:50:00,000000000' AND SAMPLE_TIME < '28/07/15 14:56:00,000000000'
 AND SQL_ID IS NOT NULL
 ORDER BY SAMPLE_TIME

--History (with user)
--History (with user)
SELECT INSTANCE_NUMBER,
 SESSION_ID,
 DBA_USERS.USERNAME,
 MACHINE,
 SAMPLE_TIME, --05/07/15 23:22:00,324000000
 SQL_ID, 
 SQL_PLAN_HASH_VALUE, 
 WAIT_CLASS, 
 WAIT_TIME,
 TIME_WAITED
 FROM DBA_HIST_ACTIVE_SESS_HISTORY
 JOIN DBA_USERS ON (DBA_HIST_ACTIVE_SESS_HISTORY.user_id=DBA_USERS.user_id)
 WHERE SAMPLE_TIME > '09/06/20 00:00:00,000000000' AND SAMPLE_TIME < '09/06/20 01:00:00,000000000'
 AND SQL_ID IS NOT NULL
 and DBA_USERS.USERNAME='OPS$ORACLE'
  --AND SQL_ID='9pw8f3dd8rrwm'
 ORDER BY SAMPLE_TIME
 

--SQL_ID
SELECT   REPLACE (TRANSLATE (sql_text, '0123456789', '999999999'), '9', ''),sql_id
FROM   dba_hist_sqltext s
WHERE   s.sql_id = 'ft5ur39puqg5g';




select inst_id, sample_time, session_id, wait_time, time_waited, event, b.username, sql_id, session_state, blocking_session, wait_class, 

c.object_name, current_file#, current_block#, program, session_type 
from gv$active_session_history a, dba_users b, dba_objects c 
where a.USER_ID = b.user_id (+) 
and a.CURRENT_OBJ# = c.object_id (+) 
and sample_time between to_date('2015-08-25 10:50:24', 'YYYY-MM-DD HH24:MI:SS') and 
to_date('2015-08-25 10:52:24', 'YYYY-MM-DD HH24:MI:SS') 
-- and time_waited > 10000 
-- and username not in ('SYS') 
order by sample_time;


 
 --Execution Plan
 @@SQL_HISTORY1 ddkgj7p1ybfwu



--Event delay
select
SESSION_ID,
SQL_ID,
SESSION_STATE,
EVENT,
case SESSION_STATE
when 'WAITING' then event
else SESSION_STATE
end TIME_CATEGORY,
(count(*)*10) seconds
from DBA_HIST_ACTIVE_SESS_HISTORY a,
V$INSTANCE i,
dba_users u
where a.user_id = u.user_id 
and a.instance_number = i.instance_number 
and a.user_id = u.user_id 
and sample_time between to_date('2015-07-30 13:52','YYYY-MM-DD HH24:MI') and to_date('2015-07-30 13:55','YYYY-MM-DD HH24:MI')
--and a.sql_id = 'ddkgj7p1ybfwu'
group by SESSION_ID,SQL_ID,SESSION_STATE,EVENT
order by seconds;

--Time spent
SELECT E.SAMPLE_TIME-S.SAMPLE_TIME AS SPENT_TIME
 FROM DBA_HIST_ACTIVE_SESS_HISTORY S, DBA_HIST_ACTIVE_SESS_HISTORY E
 WHERE S.sample_id = (select min(sample_id) from DBA_HIST_ACTIVE_SESS_HISTORY where sql_id = 'ddkgj7p1ybfwu' AND SESSION_ID=787 AND SAMPLE_TIME BETWEEN '30/07/15 13:50:00,000000000' AND '30/07/15 13:55:00,000000000')
 AND E.sample_id = (select max(sample_id) from DBA_HIST_ACTIVE_SESS_HISTORY where sql_id = 'ddkgj7p1ybfwu' AND SESSION_ID=787 AND SAMPLE_TIME BETWEEN '30/07/15 13:50:00,000000000' AND '30/07/15 13:55:00,000000000')
 GROUP BY E.SAMPLE_TIME-S.SAMPLE_TIME


--Execs
select  to_char(s.begin_interval_time, 'DD-MON HH24:MI') snap_time,
        ss.executions_delta execs,
        ss.buffer_gets_delta/decode(ss.executions_delta,0,1,ss.executions_delta) lio_per_exec,
        ss.disk_reads_delta/decode(ss.executions_delta,0,1,ss.executions_delta) pio_per_exec,
        (ss.cpu_time_delta/1000000)/decode(ss.executions_delta,0,1,ss.executions_delta) cpu_per_exec,
        (ss.elapsed_time_delta/1000000)/decode(ss.executions_delta,0,1,ss.executions_delta) ela_per_exec
from    dba_hist_snapshot       s,
        dba_hist_sqlstat        ss
where   ss.dbid = s.dbid
and     ss.instance_number = s.instance_number
and     ss.snap_id = s.snap_id
and     ss.sql_id = 'dkgmg2sn955kz'
--and   ss.executions_delta > 0
and     s.begin_interval_time >= sysdate - 10
order by s.snap_id;