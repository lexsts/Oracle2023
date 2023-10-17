--CHECK TABLESPACE WITH FREESPACE
SET PAGESIZE 140 LINESIZE 200
COLUMN used_pct FORMAT A11

SELECT tablespace_name,
       size_mb,
       free_mb,
       max_size_mb,
       max_free_mb,
       TRUNC((max_free_mb/max_size_mb) * 100) AS free_pct,
       RPAD(' '|| RPAD('X',ROUND((max_size_mb-max_free_mb)/max_size_mb*10,0), 'X'),11,'-') AS used_pct
FROM   (
        SELECT a.tablespace_name,
               b.size_mb,
               a.free_mb,
               b.max_size_mb,
               a.free_mb + (b.max_size_mb - b.size_mb) AS max_free_mb
        FROM   (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024) AS free_mb
                FROM   dba_free_space
                GROUP BY tablespace_name) a,
               (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024) AS size_mb,
                       TRUNC(SUM(GREATEST(bytes,maxbytes))/1024/1024) AS max_size_mb
                FROM   dba_data_files
                GROUP BY tablespace_name) b
        WHERE  a.tablespace_name = b.tablespace_name
       )
ORDER BY tablespace_name;
SET PAGESIZE 14

#MOVE TABLE AND REBUILD

select 'alter table '||owner||'.'||segment_name||'  move tablespace TS_BDSERVICO_DATA;' from dba_segments where tablespace_name = 'TS_BDSERVICO_DATA' and segment_type='TABLE';

select 'alter index '||owner||'.'||segment_name||'  rebuild online parallel (degree 14);' from dba_segments where tablespace_name = 'TS_BDSERVICO_DATA' and segment_type='INDEX';



--CHECK HIGHWATER
select a.tablespace_name, a.file_name,(b.maximum+c.blocks-1)*d.db_block_size highwater
from dba_data_files a,(select file_id,max(block_id)
     maximum from dba_extents group by file_id) b ,dba_extents c ,
     (select value db_block_size from v$parameter
     where name='db_block_size') d
where a.file_id = b.file_id
      and c.file_id = b.file_id
      and c.block_id = b.maximum
order by a.tablespace_name,a.file_name
 


--SHRINK TABLESPACE 
ALTER TABLESPACE reclaim_ts COALESCE;


--RESIZE DATAFILES
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/DB11G/reclaim01.dbf' RESIZE 5M;