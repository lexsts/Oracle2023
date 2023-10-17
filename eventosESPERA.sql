col username format a15
col event format a25
col P1TEXT format a15
col P2TEXT format a15
col P3TEXT format a15
select s.inst_id, s.sid, s.serial#, substr(s.username, 1, 15) username, s.sql_hash_value, s.sql_id,
  substr(w.event, 1, 25) event, w.seconds_in_wait, substr(w.p1text, 1, 15) p1text, w.p1, w.p1raw,
  substr(w.p2text, 1, 15) p2text, w.p2, substr(w.p3text, 1, 15) p3text, w.p3
from gv$session_wait w, gv$session s
where
  w.inst_id = s.inst_id
  and w.sid = s.sid
  and s.status = 'ACTIVE'
  and w.event not in ('SQL*Net message from client', 'rdbms ipc message', 
    'pmon timer', 'smon timer', 'SQL*Net message to client')
  and s.wait_class != 'Idle'
order by seconds_in_wait;
