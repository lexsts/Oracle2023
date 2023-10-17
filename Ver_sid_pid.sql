Select SID,SERIAL#,USERNAME,STATUS 
from v$session where paddr in (select addr from v$process where spid='xxxxxxxx');