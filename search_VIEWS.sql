drop table TMP_SOURCE_VIEWS
create table TMP_SOURCE_VIEWS as select owner, view_name, TO_LOB(text) TEXTO from dba_views 
SELECT * FROM TMP_SOURCE_VIEWS where UPPER(texto) LIKE '%GET_CLASSIFICACAO_OPERACAO%'; 
