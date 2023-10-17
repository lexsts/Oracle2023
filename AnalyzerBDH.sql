select owner,
table_name,
num_rows,
sample_size,
to_char(last_analyzed,'hh24:mi:ss dd/mm/yy') last_analyzed
from dba_tables 
where last_analyzed>'25/05/22' --dia atual
order by last_analyzed