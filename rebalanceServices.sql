$ srvctl status service -d RPNEMSPA
Service NEM1P is running on instance(s) RPNEMSPA1
Service NEM2P is running on instance(s) RPNEMSPA1 <--
Service NEMP is running on instance(s) RPNEMSPA1


$ srvctl stop service -d RPNEMSPA

$ srvctl start service -d RPNEMSPA

$ srvctl status service -d RPNEMSPA
Service NEM1P is running on instance(s) RPNEMSPA1
Service NEM2P is running on instance(s) RPNEMSPA2 <--
Service NEMP is running on instance(s) RPNEMSPA1



$ORACLE_HOME/bin/srvctl relocate service -db RPIPNSPA -service cordap -oldinst RPIPNSPA2 -newinst RPIPNSPA1