CREATE OR REPLACE PROCEDURE SYS.PROC_STATISTICS_CONCILIACAO IS
BEGIN
--Remove o plano de execução do dia anterior na instrução IN abaixo:
Declare 
Cursor Cur_SQLIDs Is
      select address||','||hash_value as HASH from gv$sqlarea where sql_id IN ('2y12wa43pjnpb','a4nkt10sc5qx8','fmayrny92gpam','bpkj0q8hc5b7x','6takcy6antp3a','39w8b9zfd23bf','c91mzq33jyymc','20knyyvgjrrj5','3zdy9xk9rva86','7r4nj7pj15hsd','f03nsb2g2mbfp');
      SQLIDs Cur_SQLIDs%ROWTYPE;
Begin
    OPEN Cur_SQLIDs;   
    LOOP
        FETCH Cur_SQLIDs INTO SQLIDs;
        dbms_shared_pool.purge(''||SQLIDs.HASH||'','C',1);
        EXIT WHEN Cur_SQLIDs%NOTFOUND;        
    END LOOP;    
    CLOSE Cur_SQLIDs;
End;
							--Atualiza as estatisticas das tabelas/indices
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'HIST_CART_COMIT_I_NUM_IF', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'HIST_CART_COMIT_I_NUM_CTA_PART', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'HIST_CART_COMIT_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'D_OPER_OPER_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IDX$$_24C020002', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'D_OPER_PCK_COMP_DEB_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_CONS_NOME_APLIC_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_T_OP_OB_SE_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_TIPO_DEB_P2_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_TIPO_DEB_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_ST_OPERAC_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_SITUAC_MODALID_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_MOD_LIQUID_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_F_TESTA_MEU_NUM_P2_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_F_TESTA_MEU_NUM_P1_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_CONTA_PART_P2_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_CONTA_PART_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'COD_OPERACAO_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_OP_TP_OB_SERV_COD_ORIG_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_ST_OPERAC_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IE41_INSTRUMENTO_FINANCEIRO', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_V_POSIC_CUST_MALOTE_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_V_POSICAO_SWAP_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_NUM_IF_COD_IF_TIPO_IF', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_1_TIPO_IF_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_1_PK', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_V_CONTRATOS_TERMO', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_MOT_SIT_IF_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'IF_1_SIST_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPERACAO_I_NUM_ID_OPERACAO_COD', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'OPER_PK', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'EXTR_MOVIMENTO_PK', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'JUR_FLUT_V_POSICAO_SWAP_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'JU_FLUT_PK', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'HIST_CART_COMIT_I_COD_TIPO_IF', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);
								dbms_stats.gather_table_stats(ownname => 'CETIP', tabname =>'T_TMP_HIST_CARTEIRA_PARTIC_V2', DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_if',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_titulo',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_hist_pu_curva',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_credito',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_conta_participante',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_conta_ag_fiduc_emis',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_condicao_if_emissao',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_imob_lote_emissao',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'t_tmp_resgate_t21',DEGREE => 32);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'PAR_PONTA_IF_FK', DEGREE => 32);								
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'CONTA_PARTICIPANTE',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'PESSOA_JURIDICA',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'HIST_CARTEIRA_PARTICIPANTE',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'CONTROLE_OPERACIONAL',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'TIPO_IF',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'TITULO',DEGREE => 32);
								dbms_stats.gather_table_stats(ownname => 'CETIP', TABNAME =>'INSTRUMENTO_FINANCEIRO',DEGREE => 32);
								dbms_stats.gather_index_stats(ownname => 'CETIP', indname =>'JU_FLUT_IND_VAL_FK_I', estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);

								EXCEPTION
								WHEN NO_DATA_FOUND THEN
								raise_application_error (-20001,'Nao há plano no cache para um dos SQL_IDs.');
								raise_application_error (-20002,'Ocorreu um erro. Execute o bloco manualmente para identifica-lo.');
END;    
/    



BEGIN
DBMS_SCHEDULER.DROP_JOB ('STATISTICS_CONCILIACAO');
END;
/

BEGIN
 DBMS_SCHEDULER.CREATE_JOB (
   job_name            =>  'STATISTICS_CONCILIACAO', 
   job_type            =>  'STORED_PROCEDURE',
   job_action          =>  'SYS.PROC_STATISTICS_CONCILIACAO',
   start_date          =>  '23/07/21 01:00:00,000000000 -03:00',
   repeat_interval     =>  'FREQ=DAILY;BYHOUR=1;BYDAY=MON,TUE,WED,THU,FRI',
   enabled              =>  TRUE,
   comments            =>  'Job de estatísticas - Diário as 01:00hrs - Jobs: CONCILIACAO');
END;
/