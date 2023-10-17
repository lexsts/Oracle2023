set serveroutput on

exec DS_CS_GR_SCHEMAS ( 'PR01SPBO' , 'PR01SPBU', 'SPBEX', 'SPBRW', 'SPBRO' );


exec DS_CS_GR_SCHEMAS ( 'JSA' , 'PR02BSIU', 'JSAEX', 'JSARW', 'JSARO' );
exec DS_CS_GR_SCHEMAS ( 'IFW' , 'PR02BSIU', 'IFWEX', 'IFWRW', 'IFWRO' );
exec DS_CS_GR_SCHEMAS ( 'PIN' , 'PR02BSIU', 'PINEX', 'PINRW', 'PINRO' );


exec DS_CS_GR_SCHEMAS ( 'PR01CLYO' , 'PR01CLYU', 'PRCLYEX', 'PRCLYRW', 'PRCLYRO' );
exec DS_CS_GR_SCHEMAS ( 'PR01WPTO' , 'PR01WPTU', 'PRWPTEX', 'PRWPTRW', 'PRWPTRO' );
exec DS_CS_GR_SCHEMAS ( 'PR01INTO' , 'PR01INTU', 'PRINTEX', 'PRINTRW', 'PRINTRO' );



select 'GRANT SELECT,INSERT,UPDATE,DELETE ON '||owner||'.'||object_name||' TO &USUARIO_USR;'
from dba_objects
where owner='&USUARIO_DBA' and object_type='TABLE'
order by object_name;

select 'GRANT SELECT ON '||owner||'.'||object_name||' TO &USUARIO_USR;'
from dba_objects
where owner='&USUARIO_DBA' and object_type in ('SEQUENCE')
order by object_name;

select 'GRANT EXECUTE ON '||owner||'.'||object_name||' TO &USUARIO_USR;'
from dba_objects
where owner='&USUARIO_DBA' and object_type in ('FUNCTION','PROCEDURE')
order by object_name;

select 'GRANT SELECT ON '||owner||'.'||object_name||' TO &USUARIO_USR;'
from dba_objects
where owner='&USUARIO_DBA' and object_type in ('VIEW')
order by object_name;


-- SYNONYMS

select 'CREATE SYNONYM &USUARIO_USR'||'.'||object_name||' FOR '||owner||'.'||object_name||';'
from dba_objects
where owner='&USUARIO_DBA' and object_type IN ('TABLE','SEQUENCE','FUNCTION','PROCEDURE','VIEW')
order by object_name;
