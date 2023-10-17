--Dia atual 29/04/2020

--Arquivo depositaria.sql
BEGIN CETIP.P_GERA_ARQ_MONIT_CDB ( '20200429', 'DEPOSITARIA-20200428-MONITORAMENTO_POSICAO_CDB.txt' ); END;
/

--Chamada em backgroup
nohup sqlplus "/ as sysdba" @depositaria.sql &