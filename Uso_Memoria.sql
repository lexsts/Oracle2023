SELECT a.UGA_MEMORY, 
       b.PGA_MEMORY,
       E.SID,
       E.SERIAL#,
       E.USERNAME,
       E.STATUS,
       E.SCHEMANAME,
       E.OSUSER,
       E.MACHINE,
       E.TERMINAL,
       E.PROGRAM,
       E.MODULE,
       E.LOGON_TIME
  FROM -- Current UGA size for the session.
        (select y.SID,
                TO_CHAR(ROUND(y.value / 1024 / 1024), 99999999) || ' MB' UGA_MEMORY
           from v$sesstat y, v$statname z
          where y.STATISTIC# = z.STATISTIC# and NAME = 'session uga memory') a,
       -- Current PGA size for the session.
       (select y.SID,
               TO_CHAR(ROUND(y.value / 1024 / 1024), 99999999) || ' MB' PGA_MEMORY
          from v$sesstat y, v$statname z
         where y.STATISTIC# = z.STATISTIC# and NAME = 'session pga memory') b,
       v$session e
 WHERE e.sid = a.sid AND e.sid = b.sid
 ORDER BY b.PGA_MEMORY desc, a.UGA_MEMORY desc, e.status,  E.USERNAME, E.SCHEMANAME, E.STATUS, E.MACHINE, E.TERMINAL, E.OSUSER, E.PROGRAM;