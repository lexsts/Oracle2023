rman target /
startup mount;
catalog start with '/oraclebk_new/CETIP/bckon/' noprompt;
catalog start with '/oraclebk_new/CETIP/bckarchon/' noprompt;
run
{
set UNTIL TIME "to_date('02/13/2023 23:56:00','mm/dd/yyyy hh24:mi:ss')";
restore database;
recover database;
}
alter database open resetlogs;


nohup rman target / cmdfile=/home/oracle/recover_rman.src msglog=/home/oracle/recover_rman.log &