##GET DEVICE
as root execute: acfsutil info fs
[root@orafin00401p IFAT]# acfsutil info fs
/oracle
    ACFS Version: 12.2.0.1.0
    on-disk version:       46.0
    compatible.advm:       12.2.0.0.0
    ACFS compatibility:    12.2.0.0.0
    flags:        MountPoint,Available
    mount time:   Thu Sep 30 12:21:50 2021
    mount sequence number: 7
    allocation unit:       4096
    metadata block size:   4096
    volumes:      1
    total size:   428959858688  ( 399.50 GB )
    total free:   261104406528  ( 243.17 GB )
    file entry table allocation: 17170432
    primary volume: /dev/asm/oracle-473       <--------------------------AQUI
        label:
        state:                 Available
        major, minor:          252, 242177
        logical sector size:   512
        size:                  428959858688  ( 399.50 GB )
        free:                  261104406528  ( 243.17 GB )
        metadata read I/O count:         130099
        metadata write I/O count:        5076
        total metadata bytes read:       581615616  ( 554.67 MB )
        total metadata bytes written:    105218048  ( 100.34 MB )
        ADVM diskgroup:        ORACLE
        ADVM resize increment: 67108864
        ADVM redundancy:       unprotected
        ADVM stripe columns:   8
        ADVM stripe width:     1048576
    number of snapshots:  0
    snapshot space usage: 0  ( 0.00 )
    replication status: DISABLED
    compression status: DISABLED

	OU
	
ASMCMD> volinfo --all
Diskgroup Name: ACFSDG
Volume Name: ACFSVG
Volume Device: /dev/asm/acfsvg-278
State: ENABLED
Size (MB): 500032
Resize Unit (MB): 64
Redundancy: UNPROT
Stripe Columns: 8
Stripe Width (K): 1024
Usage:
Mountpath:	

##RESTART ACFS	
srvctl stop filesystem -device /dev/asm/oracle-473 -node orafin00401p
srvctl start filesystem -device /dev/asm/oracle-473 -node orafin00401p

srvctl stop filesystem -device /dev/asm/oracle-145 -node orafin00302p
srvctl start filesystem -device /dev/asm/oracle-145 -node orafin00302p

srvctl stop filesystem -device /dev/asm/oracle-12 -node orafin00201p
srvctl start filesystem -device /dev/asm/oracle-12 -node orafin00201p

srvctl stop filesystem -device /dev/asm/oracle-389 -node oraseg00202p
srvctl start filesystem -device /dev/asm/oracle-389 -node oraseg00202p

###QUANDO O ACFS NÃO ESTIVER MONTADO:
#CHECA OS VOLUMES
/u01/app/grid/product/18.0.0/grid/bin/./crsctl stat res -w "TYPE = ora.acfs.type" -p | grep VOLUME
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/ghchkpt-148
VOLUME_DEVICE=/dev/asm/ghchkpt-148
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/ghchkpt-148
VOLUME_DEVICE=/dev/asm/ghchkpt-148
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/oracle-114
VOLUME_DEVICE=/dev/asm/oracle-114
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/oracle-114
VOLUME_DEVICE=/dev/asm/oracle-114


AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/ghchkpt-334
VOLUME_DEVICE=/dev/asm/ghchkpt-334
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/ghchkpt-334
VOLUME_DEVICE=/dev/asm/ghchkpt-334
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/oracle-389
VOLUME_DEVICE=/dev/asm/oracle-389
AUX_VOLUMES=
CANONICAL_VOLUME_DEVICE=/dev/asm/oracle-389
VOLUME_DEVICE=/dev/asm/oracle-389

#MONTA O ACFS
/u01/app/grid/product/18.0.0/grid/bin/srvctl stop filesystem -d /dev/asm/oracle-114 -n orabal00602p
/u01/app/grid/product/18.0.0/grid/bin/srvctl start filesystem -d /dev/asm/oracle-114 -n orabal00601p


/bin/mount -t acfs /dev/asm/acfsvg-330 /home/oracle/export

asmcmd
##check disks que pertencem a um diskgroup
select a.NAME, a.TOTAL_MB, a.FREE_MB, b.NAME "DISK NAME", b.READS, b.WRITES, b.BYTES_READ/1024/1024/1024 BR_GB, b.BYTES_WRITTEN/1024/1024/1024 BW_GB
  from v$asm_diskgroup a join v$asm_disk b
  on(a.GROUP_NUMBER=b.GROUP_NUMBER)
  and a.NAME = 'ORACLE';


