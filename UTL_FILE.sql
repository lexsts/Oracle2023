declare
   file_handle UTL_FILE.FILE_TYPE; 
   texto varchar2(3000);
BEGIN   
   file_handle := UTL_FILE.FOPEN('DIR_ARQ_BATCH', 'TESTE.TXT', 'W', 8196);
   UTL_FILE.PUT_LINE (file_handle, 'teste1');
   UTL_FILE.PUT_LINE (file_handle, 'teste2');
   UTL_FILE.PUT_LINE (file_handle, 'teste3');
   UTL_FILE.FCLOSE(file_handle);
end;
   
   
DECLARE
  file_name VARCHAR2(256) := 'TESTE.TXT';
  file_text VARCHAR2(100) := '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
  file_id UTL_FILE.file_type;
BEGIN
  file_id := UTL_FILE.fopen('DIR_ARQ_BATCH', file_name, 'W');
  FOR x IN 1..1030 LOOP -- write 11 records
     UTL_FILE.put_line(file_id, file_text);
  END LOOP;

  UTL_FILE.fclose(file_id);

END;
/   
