--EVENTO DE ESPERA - enq: TX - allocate ITL entry
--CHECK INITRANS AND PCTFREE IN TABLE AND INDEX
SELECT * FROM DBA_TABLES
SELECT * FROM DBA_INDEXES

--CHANGE THE PCTFREE AND INITRANS
alter table GRCR.PATRIMONIO_VEICULAR_ANALITICO PCTFREE 20  INITRANS 10;
alter table GRCR.PATRIMONIO_VEICULAR_ANALITICO MOVE;
alter index GRCR.INX_PVAN_02 rebuild online PCTFREE 20 INITRANS 10;
alter index GRCR.INX_PVAN_03 rebuild online PCTFREE 20 INITRANS 10;
alter index GRCR.INX_PVAN_04  rebuild online PCTFREE 20 INITRANS 10;