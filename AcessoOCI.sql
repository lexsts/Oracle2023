acessos
REQ000002342494

bascor0101p
ssh -i C:\Users\alexsantos\Downloads\priv_oci_exa.ppk oci@10.158.30.178

https://www.oracle.com/cloud/sign-in.html?redirect_uri=https%3A%2F%2Fcloud.oracle.com%2F

https://www.oracle.com/cloud/sign-in.html?redirect_uri=https%3A%2F%2Fcloud.oracle.com%2F
acessando a oci
login as: opc
-- vai direto
--------------------------------------------------
[opc@exacs1p-clu1-4xtxu1 ~]$ sudo su - oracle
Last login: Mon Feb 13 18:31:29 -03 2023
[oracle@exacs1p-clu1-4xtxu1 ~]$
--------------------------------------------------
[oracle@exacs1p-clu1-4xtxu1 ~]$ ps -ef | grep pmon
grid      73216      1  0  2022 ?        00:06:55 asm_pmon_+ASM1
grid      95934      1  0  2022 ?        00:07:44 apx_pmon_+APX1
oracle   100252      1  0  2022 ?        00:09:47 ora_pmon_CPSEGREP1
oracle   190147 186580  0 18:32 pts/0    00:00:00 grep --color=auto pmon
oracle   344083      1  0  2022 ?        01:37:37 ora_pmon_CPSEGOCA1
[oracle@exacs1p-clu1-4xtxu1 ~]$
--------------------------------------------------
Multitenant - container
- history
 . CPSEGREP.env -- container da replica de produção
 . CPSEGOCA.env --produção -- entrar na produção **ATENÇÃO*** PARA SETAR
sqlplus / as sysdba -- entrar no banco de dados
select pdb_name from dba_pdbs; -- rodar essa query enorme :)
------------------------------------
SQL> select pdb_name from dba_pdbs; --- rodar para visualizar
PDB_NAME
--------------------------------------------------------------------------------
RPSEGOCA
PDB$SEED
RPRESOCA
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
utilizar os 2 que mais importa
*******Atenção, vc esta entrando em containers de Produção*******
RPSEGOCA ---- plugable database de SEGUROS
PDB$SEED
RPRESOCA ---- plugable database de RESEGUROS ***atenção SOCAAAAA** TAS000001701131
ALTER SESSION SET CONTAINER=RPSEGOCA; -- vai entrar no container de seguros --NÃO EXECUTAR
ALTER SESSION SET CONTAINER=RPRESOCA; -- vai entrar no container de reseguros --TAS000001701131
**valida o container**
SQL> show con_name;
CON_NAME
------------------------------
RPSEGOCA
SQL>