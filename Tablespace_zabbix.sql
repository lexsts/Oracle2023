SELECT ABC.FILE_NAME,
       ROUND(ABC.BYTES/1024/1024) AS BYTES,
       ABC.AUTOEXTENSIBLE,
       ROUND(ABC.MAXBYTES/1024/1024) AS MAXBYTES,
       TBSUSED.*,
       NDT.N_DATAFILES,
       'ALTER DATABASE DATAFILE ''' || ABC.FILE_NAME || ''' AUTOEXTEND ON NEXT ' ||
               CASE
                 WHEN TBSUSED.USED_MB < 3000 THEN '50M'
                 WHEN TBSUSED.USED_MB >= 3000 AND TBSUSED.USED_MB <= 6000 THEN '100M'
                 WHEN TBSUSED.USED_MB > 6000 THEN '200M'                   
               END || ' MAXSIZE ' ||
               CASE
                 WHEN TBSUSED.USED_MB < 1500 THEN ROUND((TBSUSED.USED_MB/NDT.N_DATAFILES) + (200/NDT.N_DATAFILES))
                 WHEN TBSUSED.USED_MB >= 1500 AND TBSUSED.USED_MB < 3000 THEN ROUND((TBSUSED.USED_MB/NDT.N_DATAFILES) + (500/NDT.N_DATAFILES))
                 WHEN TBSUSED.USED_MB >= 3000 AND TBSUSED.USED_MB <= 6000 THEN ROUND((TBSUSED.USED_MB/NDT.N_DATAFILES) + (1000/NDT.N_DATAFILES))
                 WHEN TBSUSED.USED_MB > 6000 THEN ROUND((TBSUSED.USED_MB/NDT.N_DATAFILES) + (1500/NDT.N_DATAFILES))
               END || 'M; -- ' || TBSUSED.USED_MB || ' USED ' ||  TBSUSED.TABLESPACE_NAME AS  TBS_RESIZE_CMD
              
  FROM DBA_DATA_FILES ABC,
(
SELECT --'SAOSHDBP0064-MIDS' AS DATABASE,
       FIM.TABLESPACE_NAME,
       FIM.USED_MB,
       FIM.FREE_MB,
       FIM.TOTAL_MB,
       FIM."%UTILIZATION"
  FROM (SELECT --'SAOSHDBP0064-MIDS' AS DATABASE,
               TSU.TABLESPACE_NAME,
               ROUND(NVL(TSF.USED_MB,0)) USED_MB, 
               ROUND(TSU.TOTAL_MB-NVL(TSF.USED_MB,0)) FREE_MB, 
               ROUND(NVL(TSU.TOTAL_MB,0)) TOTAL_MB,
               NVL(ROUND((TSF.USED_MB*100/TSU.TOTAL_MB)),0) "%UTILIZATION"
          FROM (SELECT TEMP_ALL.TABLESPACE_NAME,
                       SUM(TEMP_ALL.TOTAL_MB) TOTAL_MB
                  FROM (SELECT TABLESPACE_NAME,
                               CASE
                                  WHEN BYTES > MAXBYTES AND MAXBYTES > 0 AND AUTOEXTENSIBLE = 'YES' THEN BYTES/1024/1024
                                  WHEN BYTES > MAXBYTES AND AUTOEXTENSIBLE = 'NO' THEN BYTES/1024/1024
                               END TOTAL_MB
                          FROM DBA_DATA_FILES 
                         UNION ALL
                        SELECT TABLESPACE_NAME,
                               CASE
                                  WHEN BYTES < MAXBYTES AND AUTOEXTENSIBLE = 'YES' THEN MAXBYTES/1024/1024
                                  WHEN BYTES = MAXBYTES AND AUTOEXTENSIBLE = 'YES' THEN MAXBYTES/1024/1024                            
                               END TOTAL_MB
                          FROM DBA_DATA_FILES) TEMP_ALL
                GROUP BY TEMP_ALL.TABLESPACE_NAME) TSU,
               (SELECT TABLESPACE_NAME,
                       ROUND(SUM(BYTES)/1024/1024,2) USED_MB
                  FROM DBA_SEGMENTS GROUP BY TABLESPACE_NAME) TSF
         WHERE TSU.TABLESPACE_NAME = TSF.TABLESPACE_NAME (+)
        --   AND TSU.TABLESPACE_NAME NOT LIKE '%UNDO%'
           AND TSU.TABLESPACE_NAME NOT LIKE '%TEMP%'
        --ORDER BY TSU.TOTAL_MB, TSF.USED_MB, TSU.TABLESPACE_NAME
        UNION ALL
        SELECT --'SAOSHDBP0064-MIDS' AS DATABASE,
               TSU.TABLESPACE_NAME,
               ROUND(NVL(TSF.USED_MB,0)) USED_MB, 
               ROUND(TSU.TOTAL_MB-NVL(TSF.USED_MB,0)) FREE_MB, 
               ROUND(NVL(TSU.TOTAL_MB,0)) TOTAL_MB,
               NVL(ROUND((TSF.USED_MB*100/TSU.TOTAL_MB)),0) "%UTILIZATION"
          FROM (SELECT TEMP_ALL.TABLESPACE_NAME,
                       SUM(TEMP_ALL.TOTAL_MB) TOTAL_MB
                  FROM (SELECT TABLESPACE_NAME,
                               CASE
                                  WHEN BYTES > MAXBYTES AND MAXBYTES > 0 AND AUTOEXTENSIBLE = 'YES' THEN BYTES/1024/1024
                                  WHEN BYTES > MAXBYTES AND AUTOEXTENSIBLE = 'NO' THEN BYTES/1024/1024
                               END TOTAL_MB
                          FROM DBA_TEMP_FILES 
                         UNION ALL
                        SELECT TABLESPACE_NAME,
                               CASE
                                  WHEN BYTES < MAXBYTES AND AUTOEXTENSIBLE = 'YES' THEN MAXBYTES/1024/1024
                                  WHEN BYTES = MAXBYTES AND AUTOEXTENSIBLE = 'YES' THEN MAXBYTES/1024/1024                            
                               END TOTAL_MB
                          FROM DBA_TEMP_FILES) TEMP_ALL
                GROUP BY TEMP_ALL.TABLESPACE_NAME) TSU,
               (SELECT TAREA.TABLESPACE_NAME,
                       TAREA.USED_BLOCKS*BL.BLOCK_SIZE/1024 AS USED_MB
                       --TAREA.FREE_BLOCKS*BL.BLOCK_SIZE/1024 AS FREE_MB,
                       --TAREA.TOTAL_BLOCKS*BL.BLOCK_SIZE/1024 AS TOTAL_MB
                  FROM V$SORT_SEGMENT TAREA,
                       (SELECT BLOC.VALUE/1024 AS BLOCK_SIZE
                          FROM V$PARAMETER BLOC
                         WHERE BLOC.NAME = 'db_block_size') BL) TSF
         WHERE TSU.TABLESPACE_NAME = TSF.TABLESPACE_NAME (+)) FIM
ORDER BY FIM."%UTILIZATION"
) TBSUSED,
    (
    SELECT CNT.TABLESPACE_NAME,
           COUNT(CNT.FILE_NAME) N_DATAFILES
      FROM DBA_DATA_FILES CNT
    GROUP BY CNT.TABLESPACE_NAME
    ) NDT

 WHERE ABC.TABLESPACE_NAME = TBSUSED.TABLESPACE_NAME
   AND ABC.TABLESPACE_NAME = NDT.TABLESPACE_NAME
ORDER BY TBSUSED.USED_MB 