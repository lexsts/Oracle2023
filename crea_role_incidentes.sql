rem -----------------------------------------------------------------------
rem Name  : crea_role_cspn.sql
rem Author: gmonteiro
rem Date  : 24/10/2012
rem Desc  : Cria Role Perfil de Incidentes
rem Obs	  : Esta role tem acesso Leitura e Escrita em tabelas e Execução em Procedures/Functions
rem -----------------------------------------------------------------------

CREATE ROLE ROLE_INCIDENTES;
GRANT CONNECT TO ROLE_INCIDENTES;

GRANT SELECT ANY TABLE TO ROLE_INCIDENTES;
GRANT INSERT ANY TABLE TO ROLE_INCIDENTES;
GRANT UPDATE ANY TABLE TO ROLE_INCIDENTES;
GRANT DELETE ANY TABLE TO ROLE_INCIDENTES;
GRANT EXECUTE ANY PROCEDURE TO ROLE_INCIDENTES;

set head on
select GRANTEE, GRANTED_ROLE, admin_option from dba_role_privs where grantee = 'ROLE_INCIDENTES';

exit