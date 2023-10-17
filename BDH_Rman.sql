V_CONTROL=/u01/oradata/BDH/bck/arControlBDH
V_BACKUP_FILE="'"/u01/oradata/BDH/bck/ar_BDH_%d%T_%t_%s_%p"'"

rman target /
run
{
SET CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '/u01/oradata/BDH/bck/arControlBDH%F';
CONFIGURE DEVICE TYPE DISK PARALLELISM 8;
ALLOCATE CHANNEL disk01  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk02  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk03  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk04  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk05  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk06  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk07  DEVICE TYPE DISK maxopenfiles 4;
ALLOCATE CHANNEL disk08  DEVICE TYPE DISK maxopenfiles 4;
backup
 incremental level 0
 filesperset 1
 format "/u01/oradata/BDH/bck/ar_BDH_%d%T_%t_%s_%p"
 archivelog all delete all input
 skip inaccessible;
 delete noprompt archivelog all backed up 1 times to DEVICE TYPE disk;
}