#VERIFICA OS ARQUIVOS DE REDO E SEUS TAMANHOS
SELECT a.group#, a.member, b.bytes
    FROM v$logfile a, v$log b 
    WHERE a.group# = b.group#;
	
	
#VERIFICA QUAL É O REDOLOG QUE ESTÁ EM USO NO MOMENTO	
select group#, status from v$log;


#FORÇA MUDANÇA DE REDOLOG
ALTER SYSTEM CHECKPOINT GLOBAL;    
ALTER SYSTEM SWITCH LOGFILE


#REMOVE UM GRUPO DE REDOLOG
alter database drop logfile group 2;


#ADICIONA UM GRUPO DE REDOLOG
alter database add logfile group 4 (
    '+DATA_IFAT',  
    '+RECO') size 20000m reuse;