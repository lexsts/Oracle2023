alter system flush buffer_cache global;


 EXEC dbms_stats.gather_schema_stats('WEB', cascade=>TRUE,degree => 32);
  EXEC dbms_stats.gather_schema_stats('MKRP', cascade=>TRUE,degree => 32);
  
   EXEC dbms_stats.gather_schema_stats('PR01ICXO', cascade=>TRUE,degree => 32);
   EXEC dbms_stats.gather_schema_stats('PR01SNDBXO', cascade=>TRUE,degree => 32);