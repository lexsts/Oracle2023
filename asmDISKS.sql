#QUERY ASMDISK
SQL> sqlplus ‘/as sysasm’
SQL> COL PATH FORMAT A15;
SQL> SELECT GROUP_NUMBER,
     DISK_NUMBER,
     MOUNT_STATUS,
     HEADER_STATUS,
     MODE_STATUS,
     STATE,
     TOTAL_MB,
     FREE_MB,
     NAME,
     PATH 
     FROM   V$ASM_DISK;

      ASMREPO01                      ORCL:ASMREPO01
      ASMREPO02                      ORCL:ASMREPO02
      ASMREPO03                      ORCL:ASMREPO03

#QUERY DISKGROUP
oracleasm listdisks

#QUERY DEVICE	  
[root@orafin00502b repo]# oracleasm querydisk -d ASMREPO01
Disk "ASMREPO01" is a valid ASM disk on device [253,8]
[root@orafin00502b repo]# oracleasm querydisk -d ASMREPO02
Disk "ASMREPO02" is a valid ASM disk on device [253,3]
[root@orafin00502b repo]# oracleasm querydisk -d ASMREPO03
Disk "ASMREPO03" is a valid ASM disk on device [253,15]
[root@orafin00502b repo]#

#QUERY DEVICE2
ls -l /dev/* | grep "253, *8" | awk '{ print $10 }'
ls -l /dev/* | grep "253, *3" | awk '{ print $10 }'
ls -l /dev/* | grep "253, *15" | awk '{ print $10 }'


#SCAN NEW LUNS (ls /sys/class/scsi_host)
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan
echo "- - -" > /sys/class/scsi_host/host3/scan

#QUERY LUNS
[root@oracor55601p dev]# ll /dev/disk/by-id
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f000027991 -> ../../sdby
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f100027991 -> ../../sdcb
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f200027991 -> ../../sdcd
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f300027991 -> ../../sdce
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f400027991 -> ../../sdch
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f500027991 -> ../../sdcj
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f600027991 -> ../../sdcl
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f700027991 -> ../../sdcn
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f800027991 -> ../../sdcp
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002f900027991 -> ../../sdcr
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002fa00027991 -> ../../sdct
lrwxrwxrwx 1 root root 10 Aug 19 23:44 scsi-360002ac000000000000002fb00027991 -> ../../sdcv

ls -ltr /dev/*