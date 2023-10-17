--verifica a tabela
SELECT TABLE_NAME,
                                                        OWNER,
                                                        OWNER_DIFF,
                                                        DAT_INI,
                                                        DAT_FIM,
                                                        RANK,
                                                        'TS_DIFF_DATA' TABLESPACE
                                           FROM BDSERVICO.T_CTRL_DIFF_TABLE A
                                          WHERE RANK = 59
                                           and TABLE_NAME='T_VIEW_V_IF_GRVM_AUX'

--remove o registro
delete  FROM BDSERVICO.T_CTRL_DIFF_TABLE A
                                          WHERE RANK = 59
                                          and TABLE_NAME='T_VIEW_V_DW_GRV_ORIGEM'                                          
                                          commit

										  
										  


Execucao 57:
Registros carregados na tabela CETIP_DIFF.ATIVO_ESCRI_CUST_DESAUTORIZADO: 78

Registros carregados na tabela CETIP_DIFF.CONTA_PARTICIPANTE_BOLSA: 10225

Registros carregados na tabela CETIP_DIFF.EVENTO_DIFUSAO: 236265

Registros carregados na tabela CETIP_DIFF.HISTORICO_NOTIONAL: 0

Registros carregados na tabela CETIP_DIFF.LOG_BAIXA_ARQUIVO: 4742

Registros carregados na tabela CETIP_DIFF.PAPEL_PJ: 0

Registros carregados na tabela CETIP_DIFF.REL_TIPO_DADO_DER_DOM: 0

Registros carregados na tabela CETIP_DIFF.STATUS_CALCULO_PU: 0

Registros carregados na tabela CETIP_DIFF.TIPO_GRADE_ACAO_DETALHE: 0

Registros carregados na tabela CETIP_DIFF.TITULO_SUSTENTAVEL: 1

BEGIN BDSERVICO.P_EXEC_DIFF('57','TRIGGER'); END;

*
ERROR at line 1:
ORA-20001: -904 - ORA-00904: "DAT_ATUALIZACAO_REGISTRO": identificador inválido
ORA-06512: em "BDSERVICO.P_EXEC_DIFF", line 144
ORA-06512: em line 1


Elapsed: 00:00:34.56
--> ERRO: Ocorreu um erro durante a criacao das tabelas de diferencas para o grupo 57



Execucao 58:
Registros carregados na tabela LEILAOSTN_DIFF.ATIVO_HIST: 0

Registros carregados na tabela CETIP_DIFF.CONTEXTO_MENSAGEM: 109495

Registros carregados na tabela CETIP_DIFF.EVENTO_DIFUSAO_GRP_INFORMACAO: 361651

Registros carregados na tabela CETIP_DIFF.HISTORICO_ORDEM: 0

Registros carregados na tabela RANGER_DIFF.LOG_EXECUCAO_BATCH: 0

Registros carregados na tabela CETIP_DIFF.PAPEL_PJ_CONTRATO: 9685

Registros carregados na tabela CETIP_DIFF.REL_TIPO_DADO_ESTR_DOM: 9

Registros carregados na tabela CETIP_DIFF.STATUS_CESTA: 0

Registros carregados na tabela CETIP_DIFF.TIPO_GRADE_IF: 0

Registros carregados na tabela CETIP_DIFF.TMP_ERRO_TRANSF_SANTANDER: 0

BEGIN BDSERVICO.P_EXEC_DIFF('58','TRIGGER'); END;

*
ERROR at line 1:
ORA-20001: -904 - ORA-00904: "DAT_ATUALIZACAO_REGISTRO": identificador inválido
ORA-06512: em "BDSERVICO.P_EXEC_DIFF", line 144
ORA-06512: em line 1





--> ERRO: Ocorreu um erro durante a criacao das tabelas de diferencas para o grupo 58
--------------------------------------------------------------------------------------------------------------------
Execucao 59:
Registros carregados na tabela CETIP_DIFF.ATIVO_PREVIC: 0

Registros carregados na tabela CETIP_DIFF.CONTRATO: 3754

Registros carregados na tabela CETIP_DIFF.EVENTO_LIQUIDACAO: 47167

Registros carregados na tabela CETIP_DIFF.HISTORICO_PU_LASTRO: 0

Registros carregados na tabela CETIP_DIFF.LOTE: 205

Registros carregados na tabela CETIP_DIFF.PAPEL_PJ_TITULO: 21

Registros carregados na tabela CETIP_DIFF.REL_TIPO_IF_IND_EXTERNO: 0

Registros carregados na tabela CETIP_DIFF.STATUS_CESTA_IF: 0

Registros carregados na tabela CETIP_DIFF.TIPO_GRUPO_ALTERACAO_IF: 0

Registros carregados na tabela CETIP_DIFF.TPOPEROBJETOSERV_TPREGIME: 0

BEGIN BDSERVICO.P_EXEC_DIFF('59','TRIGGER'); END;

*
ERROR at line 1:
ORA-20001: -904 - ORA-00904: "DAT_ATUALIZACAO_REGISTRO": identificador inválido
ORA-06512: em "BDSERVICO.P_EXEC_DIFF", line 144
ORA-06512: em line 1


Elapsed: 00:00:04.74
--> ERRO: Ocorreu um erro durante a criacao das tabelas de diferencas para o grupo 59