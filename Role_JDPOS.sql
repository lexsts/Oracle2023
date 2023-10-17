select 'grant select,insert,update,delete on JDPOS.'||object_name||' to r_jdpos_all;' 
from dba_objects where owner='JDPOS' AND OBJECT_TYPE IN ('TABLE','VIEW');

select 'grant execute on JDPOS.'||object_name||' to r_jdpos_all;' 
from dba_objects where owner='JDPOS' AND OBJECT_TYPE IN ('FUNCTION');


select 'CREATE SYNONYM JDPOS_APP.'||Object_name||' For jdpos.'||Object_name||';' 
from dba_objects where owner='JDPOS' AND OBJECT_TYPE IN ('TABLE','VIEW','FUNCTION');


grant r_jdpos_all to jdpos_app;