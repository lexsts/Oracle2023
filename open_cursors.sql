-- TOP 5 cursors per instance
select inst_id, sid, highest_open_cur, username, max_open_cur
from (
select a.inst_id, a.SID, max(a.value) as highest_open_cur, s.username, p.value as max_open_cur,row_number() over(partition by  a.inst_id order by max(a.value) desc) rnk
from gv$sesstat a, gv$statname b, gv$parameter p, gv$session s
where a.statistic# = b.statistic#
AND s.SID=a.sid
and b.name = 'opened cursors current'
and p.name= 'open_cursors'
group by p.value, a.inst_id, a.SID, s.username
)
where rnk >= 1
and rnk <=5;
