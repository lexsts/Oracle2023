###ENABLE
[root@oratrd10101p ~]# export ORACLE_SID=+ASM1
[root@oratrd10101p ~]# export ORACLE_HOME=/opt/grid/product/12.2.0/grid_1/
[root@oratrd10101p ~]# $ORACLE_HOME/bin/oclumon manage -enable diagsnap
Diagsnap option is successfully Enabled on oratrd10101p
Diagsnap option is successfully Enabled on oratrd10102p
Successfully Enabled diagsnap
[root@oratrd10101p ~]# exit



#DISABLE
oclumon manage -disable diagsnap
