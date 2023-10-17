set pagesize 5555
set linesize 500
col USERNAME for a20
col USER for a20
col OBJECT_NAME for a30
SELECT A.USERNAME , A.SID, A.SERIAL# || CONCAT(' - ', A.OSUSER) || ' ' || A.STATUS "USER", 
DECODE(XIDUSN, 0, 'WAITING', 'BLOCKING') "TRANSACTION STATUS", d.event,
C.OBJECT_NAME
FROM V$SESSION A, V$LOCKED_OBJECT B, DBA_OBJECTS C , v$session_event d
WHERE A.SID = B.SESSION_ID AND 
B.OBJECT_ID = C.OBJECT_ID 
and a.sid = d.sid
and d.sid=b.session_id
ORDER BY 2
/
