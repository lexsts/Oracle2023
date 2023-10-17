--drop materialized view cetipvm.vm_carga_operacao
--create materialized view cetiPvm.vm_carga_operacao tablespace ts_cetipvm_data as select /*+ PARALLEL (30) */ * from alexsantos.v_p_operacao


SELECT * FROM ALEXSANTOS.TMP_LOCKS_CARGA_BDH
select sysdate from dual
DROP TABLE ALEXSANTOS.TMP_LOCKS_CARGA_BDH
DESC V$SESSION
CREATE TABLE ALEXSANTOS.TMP_LOCKS_CARGA_BDH(
DATA TIMESTAMP,
OBJECT NVARCHAR2(250),
OBJECT_TYPE NVARCHAR2(250),
LOCK_MODE NVARCHAR2(250),
SID NUMBER,
SERIAL NUMBER,
STATUS VARCHAR2(8),
SPID NUMBER,
PROGRAM VARCHAR2(48),
USERNAME VARCHAR2(128),
MACHINE VARCHAR2(64),
PORT NUMBER,
LOGON_TIME DATE,
SQL_FULL_TEXT CLOB)

BEGIN
  FOR i IN 1..999999999 LOOP  -- i starts at 10, ends at 1
   INSERT INTO ALEXSANTOS.TMP_LOCKS_CARGA_BDH
SELECT current_timestamp,o.owner || '.' ||  o.object_name object,
   o.object_type,
 DECODE(l.locked_mode, 0, 'NONE'
           ,  1, '1 - Null'
           ,  2, '2 - Row Share Lock'
           ,  3, '3 - Row Exclusive Table Lock.'
           ,  4, '4 - Share Table Lock'
           ,  5, '5 - Share Row Exclusive Table Lock.'
           ,  6, '6 - Exclusive Table Lock'
           ,  locked_mode, ltrim(to_char(locked_mode,'990'))) lock_mode,
S.SID, S.SERIAL#, S.STATUS,P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.PORT , S.LOGON_TIME,SQ.SQL_FULLTEXT
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS
and o.owner NOT IN ('SYS','ALEXSANTOS');
COMMIT;
dbms_lock.sleep(3);
  END LOOP;
END;
/