select ss.value CPU,
       SE.SID,
       SE.SERIAL#,
       SE.USERNAME,
       SE.STATUS,
       SE.SCHEMANAME,
       SE.OSUSER,
       SE.MACHINE,
       SE.TERMINAL,
       SE.PROGRAM,
       SE.MODULE,
       SE.LOGON_TIME
  from v$sesstat ss, 
       v$session se
 where ss.statistic# in (select statistic# 
                           from v$statname 
                          where name = 'CPU used by this session')
   and se.sid=ss.sid 
   and ss.sid>6
order by ss.value DESC, SE.USERNAME, SE.SCHEMANAME, SE.STATUS, SE.MACHINE, SE.TERMINAL, SE.OSUSER, SE.PROGRAM;