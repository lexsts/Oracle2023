/*
ERROR at line 1:
ORA-06550: linha 1, coluna 13:
PLS-00905: object CETIP.P_GERA_ARQ_DRESUM_EMIS_DARF_V2 is invalid
ORA-06550: linha 1, coluna 7:
PL/SQL: Statement ignored
*/
  CREATE TABLE "CETIP"."T_TEMP_ARQ_DARFV2" 
   (	"UK_DRESUMOEMISSOR" VARCHAR2(80 BYTE), 
	"SIG_UF" VARCHAR2(3 BYTE) NOT NULL ENABLE, 
	"NOM_MALOTE" VARCHAR2(15 BYTE) NOT NULL ENABLE, 
	"COD_CONTA_DESTINATARIO" VARCHAR2(15 BYTE) NOT NULL ENABLE, 
	"CONTA_DESTINATARIO" NUMBER, 
	"NOME_CONTA_DESTINATARIO" VARCHAR2(100 BYTE), 
	"TIPO_DESTINATARIO" CHAR(3 BYTE), 
	"COD_CONTA_REGISTRADOR" VARCHAR2(15 BYTE), 
	"CONTA_REGISTRADOR" NUMBER, 
	"NOME_CONTA_REGISTRADOR" VARCHAR2(100 BYTE), 
	"NUM_TIPO_IF" NUMBER(3,0) NOT NULL ENABLE, 
	"COD_TIPO_IF" VARCHAR2(5 BYTE) NOT NULL ENABLE, 
	"NUM_ID_OBJETO_SERVICO" NUMBER(5,0) NOT NULL ENABLE, 
	"COD_IF_CERTIFICADO" VARCHAR2(14 BYTE), 
	"NUM_IF_PERTENCE" NUMBER, 
	"COD_CONDICAO_RESGATE" VARCHAR2(22 BYTE), 
	"IND_RESGATE_ANTECIPADO" VARCHAR2(1 BYTE), 
	"IND_REGISTRADOR" CHAR(1 BYTE), 
	"COD_IF" VARCHAR2(14 BYTE), 
	"NUM_IF" NUMBER NOT NULL ENABLE, 
	"DAT_EMISSAO" DATE, 
	"DAT_VENCIMENTO" DATE, 
	"DAT_REGISTRO" DATE, 
	"DAT_ALTERACAO_CARACTERISTICAS" DATE, 
	"VAL_UNIT_EMISSAO" NUMBER(22,8), 
	"VAL_UNIT_EMISSAO_ATUAL" NUMBER(22,8), 
	"DAT_VAL_UNIT_EMISSAO_ATUAL" DATE, 
	"VAL_PU_CURVA" NUMBER, 
	"DAT_PRECO_UNIT_JUROS" DATE, 
	"PRECO_UNIT_JUROS" NUMBER(22,8), 
	"QTD_DEPOSITADA" NUMBER(22,8), 
	"QTD_EMITIDA" NUMBER(22,8), 
	"IND_EMISSAO_PUBLICA" VARCHAR2(1 BYTE), 
	"QTD_RESGATADA" NUMBER, 
	"QTD_RETIRADA" NUMBER(14,0), 
	"VAL_TOTAL" NUMBER, 
	"COD_CONTA_AG_PAGTO" VARCHAR2(15 BYTE), 
	"CONTA_AG_PAGTO" NUMBER, 
	"NOME_CONTA_AG_PAGTO" VARCHAR2(100 BYTE), 
	"EMISSOR" VARCHAR2(20 BYTE), 
	"CARTORIO" VARCHAR2(100 BYTE), 
	"MATRICULA" VARCHAR2(200 BYTE), 
	"FORMA_PAGAMENTO" VARCHAR2(100 BYTE), 
	"RENT_INDEXADOR_TAXA_FLU" VARCHAR2(30 BYTE), 
	"DES_INDICE_OUTROS" VARCHAR2(4000 BYTE), 
	"TIPO_INDICE_OUTROS" VARCHAR2(4000 BYTE), 
	"PERIODICIDADE_CORRECAO" VARCHAR2(40 BYTE), 
	"PRO_RATA_CORRECAO" VARCHAR2(9 BYTE), 
	"TIPO_CORRECAO" VARCHAR2(34 BYTE), 
	"MES_CORRECAO_ANUAL" NUMBER(2,0), 
	"CORRECAO_PERIODO_FINAL" VARCHAR2(1 BYTE), 
	"PERCENTUAL_TAXA_FLUTUANTE" NUMBER, 
	"TAXA_JUROS_SPREAD" NUMBER, 
	"CRITERIO_CALCULO_JUROS" VARCHAR2(81 BYTE), 
	"INCORPORA_JUROS" VARCHAR2(1 BYTE), 
	"INCORPORA_JUROS_EM" DATE, 
	"VALOR_APOS_INCORPORACAO" NUMBER(22,8), 
	"PERIODICIDADE_JUROS" VARCHAR2(10 BYTE), 
	"JUROS_A_CADA" NUMBER(5,0), 
	"TIPO_UNID_TEMPO_JUROS" VARCHAR2(7 BYTE), 
	"TIPO_PRAZO_JUROS" VARCHAR2(9 BYTE), 
	"JUROS_A_PARTIR" DATE, 
	"TIPO_AMORTIZACAO" VARCHAR2(89 BYTE), 
	"TAXA_AMORTIZACAO" NUMBER(8,4), 
	"AMORTIZACAO_A_CADA" NUMBER(5,0), 
	"TIPO_UNID_TEMPO_AMORT" VARCHAR2(7 BYTE), 
	"COD_TIPO_PRAZO_AMORT" VARCHAR2(9 BYTE), 
	"AMORTIZACAO_A_PARTIR" DATE, 
	"FORMA_LIQ_EVENTO" VARCHAR2(100 BYTE), 
	"DIA_UTIL_LIQ_EVENTO" NUMBER(2,0), 
	"DATA_INICIO_RENTABILIDADE" DATE, 
	"DAT_VENCIMENTO_CREDITO" DATE, 
	"NUM_ID_CESTA_GARANTIAS" NUMBER(8,0), 
	"DES_VEICULO_GARANTIDOR" VARCHAR2(25 BYTE), 
	"IND_POSSUI_OPCOES" VARCHAR2(1 BYTE), 
	"IND_CONVERSAO_EXTINCAO" VARCHAR2(11 BYTE), 
	"IND_RECOMPRA_EMISSOR" VARCHAR2(3 BYTE), 
	"IND_TIPO_AUTORIZACAO_BC" VARCHAR2(10 BYTE), 
	"QTD_LIMITE_CONVERSIBILIDADE" VARCHAR2(40 BYTE), 
	"DES_CRITERIOS_CONVERSAO" VARCHAR2(500 BYTE), 
	"DES_ENQUADRAMENTO_REGULATORIO" VARCHAR2(25 BYTE), 
	"DES_FORMA_INTEGRALIZACAO" VARCHAR2(10 BYTE), 
	"NOM_ABREV_INDICADOR_FINANCEIRO" VARCHAR2(20 BYTE), 
	"VAL_PERCENTUAL_ENQUADRAMENTO" VARCHAR2(40 BYTE), 
	"DES_CONTRATO" VARCHAR2(4000 BYTE), 
	"NOM_FORO_ELEICAO" VARCHAR2(60 BYTE), 
	"NOM_INSTRUMENTO_CAPTACAO" VARCHAR2(60 BYTE), 
	"CONTA_ESCRITURADOR" VARCHAR2(15 BYTE), 
	"CONTA_CUSTODIANTE_NOTA" VARCHAR2(15 BYTE), 
	"VAL_JUROS_PAGO_DIA" NUMBER(22,8), 
	"VAL_PU_CURVA_COM_JUROS_DIA" NUMBER, 
	"TOTAL_PU_CURVA_COM_JUROS" NUMBER, 
	"VAL_JUROS_ULTIMO" NUMBER, 
	"VAL_TOTAL_ATUALIZADO" NUMBER, 
	"NUM_CONTROLE_INTERNO_PARTIC" VARCHAR2(10 BYTE), 
	"NOM_TIPO_REGIME_TITULO" VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	"NUM_ID_TIPO_REGIME_TITULO" NUMBER, 
	"IND_EVENTOS_CURSADOS_CETIP" VARCHAR2(3 BYTE), 
	"COD_PROGRAMA_EMISSAO" VARCHAR2(10 BYTE), 
	"NUM_SERIE_EMISSAO" NUMBER(9,0), 
	"PRAZO_MEDIO" NUMBER, 
	"COD_CONTA_AGENTE_FIDUCIARIO" VARCHAR2(15 BYTE), 
	"NOME_LOTE" VARCHAR2(11 BYTE), 
	"MUNICIP_CRED" VARCHAR2(100 BYTE), 
	"UF_CRED" VARCHAR2(3 BYTE), 
	"TP_PREDOMIN_CRED" VARCHAR2(200 BYTE), 
	"NAT_PREDOMIN_IMOB" VARCHAR2(50 BYTE), 
	"NOM_TIPO_NEGOCIADOR" VARCHAR2(60 BYTE), 
	"IND_PLATAFORMA_ELETRONICA" VARCHAR2(3 BYTE), 
	"DATA_RECOMPRA_1" DATE, 
	"PERCENTUAL_RECOMPRA_1" NUMBER, 
	"DATA_RECOMPRA_2" DATE, 
	"PERCENTUAL_RECOMPRA_2" NUMBER, 
	"DATA_RECOMPRA_3" DATE, 
	"PERCENTUAL_RECOMPRA_3" NUMBER, 
	"EMISSAO_DIGITAL" VARCHAR2(3 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_CETIP_DATA_100M" ;