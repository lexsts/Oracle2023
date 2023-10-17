SELECT D.OWNER, 
       D.SEGMENT_NAME AS SEGMENT_NAME_TAB, 
       D.SIZE_MB AS SIZE_MB_TAB, 
       D.SEGMENT_TYPE AS SEGMENT_TYPE_TAB, 
       SUM(C.SIZE_MB) AS SIZE_MB_IND, 
       C.SEGMENT_TYPE AS SEGMENT_TYPE_IND 
  FROM (SELECT A.OWNER, 
               A.SEGMENT_NAME, 
               SUM(ROUND((A.BYTES/1024/1024))) AS SIZE_MB, 
               A.SEGMENT_TYPE 
          FROM DBA_SEGMENTS A 
         WHERE A.SEGMENT_TYPE IN ('TABLE', 'TABLE SUBPARTITION', 'NESTED TABLE', 'TABLE PARTITION', 
                                  'ROLLBACK', 'LOB PARTITION', 'LOBSEGMENT', 'CLUSTER', 'TYPE2 UNDO') 
        GROUP BY A.OWNER, 
                 A.SEGMENT_NAME, 
                 A.SEGMENT_TYPE) D, 
       (SELECT A.OWNER, 
               B.TABLE_NAME, 
               A.SEGMENT_NAME,               
               A.SEGMENT_TYPE, 
               SUM(ROUND((A.BYTES/1024/1024))) AS SIZE_MB 
          FROM DBA_SEGMENTS A, 
               DBA_INDEXES B 
         WHERE A.SEGMENT_NAME = B.INDEX_NAME 
           AND A.SEGMENT_TYPE IN ('INDEX', 'INDEX PARTITION', 'LOBINDEX') 
        GROUP BY A.OWNER, 
                 B.TABLE_NAME, 
                 A.SEGMENT_NAME, 
                 A.SEGMENT_TYPE) C 
  WHERE D.OWNER = C.OWNER(+) 
    AND D.SEGMENT_NAME = C.TABLE_NAME(+) 
GROUP BY D.OWNER, D.SEGMENT_NAME, D.SIZE_MB, 
         D.SEGMENT_TYPE, C.SEGMENT_TYPE 
ORDER BY D.OWNER, D.SEGMENT_NAME  