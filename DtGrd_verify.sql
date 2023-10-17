SELECT A.SEQUENCE#,
       A.APPLIED,
       A.COMPLETION_TIME,
       A.NAME
  FROM V$ARCHIVED_LOG A
WHERE A.APPLIED='NO'
ORDER BY 1 DESC

SELECT A.SEQUENCE#,
       A.APPLIED,
       A.COMPLETION_TIME,
       A.NAME
  FROM V$ARCHIVED_LOG A
WHERE A.APPLIED='YES'
ORDER BY A.COMPLETION_TIME ASC



======================================================
spool first_noappl.txt
SELECT A.SEQUENCE#
  FROM V$ARCHIVED_LOG A
WHERE A.APPLIED='NO'
ORDER BY A.COMPLETION_TIME DESC
spool off
exit


SELECT A.SEQUENCE#
  FROM V$ARCHIVED_LOG A
WHERE A.APPLIED='YES'
ORDER BY A.COMPLETION_TIME ASC

set ORACLE_SID=WEBLDR
set comandos="c$\Program Files\GnuWin32\bin"
D:\oracle\product\102050\BIN\sqlplus sys/"Oracle#01" as sysdba @first_noappl.sql
D:\oracle\product\102050\BIN\sqlplus sys/"Oracle#01" as sysdba @last_appl.sql
more first_noappl.txt| %comandos%grep -v selecionadas | %comandos%sed "/^$/d" | %comandos%tr -d " " | %comandos%tail -1 > noappl.txt
more last_appl.txt| %comandos%grep -v selecionadas | %comandos%sed "/^$/d" | %comandos%tr -d " " | %comandos%tail -1 > appl.txt
date /t | %comandos%tr -d " " | %comandos%gawk -F"/" "{print $3\"_\"$2\"_\"$1}" > dt.txt
for /F "tokens=1 delims= " %%i in (d:\monitor\ORACLE\noappl.txt) do set noappl=%%i
for /F "tokens=1 delims= " %%i in (d:\monitor\ORACLE\appl.txt) do set appl=%%i
for /F "tokens=1 delims= " %%i in (d:\monitor\ORACLE\dt.txt) do set dt=%%i
echo 1+%appl% | %comandos%bc.exe > proximo.txt
for /F "tokens=1 delims= " %%i in (d:\monitor\ORACLE\next.txt) do set proximo=%%i
IF %proximo% LESS %noappl% (
COPY \\saoshdbp0066\e$\oracle\product\102050\oradata\weblogic\archive\weblogic\ARCHIVELOG\%dt%\*%proximo%* E:\oracle\product\102050\oradata\WEBLOGIC\archive\WEBLDR_ARC_T1_R772458250_S%proximo%.ARC
echo ALTER DATABASE REGISTER LOGFILE 'E:\oracle\product\102050\oradata\WEBLOGIC\archive\WEBLDR_ARC_T1_R772458250_S%proximo%.ARC'; > appl_archive.sql
D:\oracle\product\102050\BIN\sqlplus sys/"Oracle#01" as sysdba @appl_archive.sql
)