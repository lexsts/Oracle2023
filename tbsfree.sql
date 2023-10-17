select tsu.tablespace_name,tsu.total_mb, (tsu.total_mb-NVL(tsf.used_mb,0)) free_mb, NVL(tsf.used_mb,0) usado_mb,NVL(round((tsf.used_mb*100/tsu.total_mb),2),0) "% UTILIZAÇÃO"
from  (select tablespace_name,
              round(sum(nvl((decode(maxbytes,0,bytes)),maxbytes))/1024/1024,2)total_mb
              from    dba_data_files group by tablespace_name) tsu,
     (select tablespace_name,round(sum(bytes)/1024/1024,2) used_mb
             from dba_segments group by tablespace_name) tsf
where     tsu.tablespace_name = tsf.tablespace_name (+)
and      tsu.tablespace_name not like '%UNDO%'
and      tsu.tablespace_name not like '%TEMP%';
