-- 17/07/2012		Cria��o inicial		Ricardo C. Nunes
============================================================================================

-- @"O:\# Profile e Crit�rios de Senha\utlpwdmg10g.sql"
-- Below is the older version of the script

-- This script sets the default password resource parameters
-- This script needs to be run to enable the password features.
-- However the default resource parameters can be changed based 
-- on the need.
-- A default password complexity function is also provided.
-- This function makes the minimum complexity checks like
-- the minimum length of the password, password not same as the
-- username, etc. The user may enhance this function according to
-- the need.
-- This function must be created in SYS schema.
-- connect sys/<password> as sysdba before running the script


Prompt Criando Fun��o de senha:
Prompt ==========================


CREATE OR REPLACE FUNCTION verify_function
(username varchar2,
  password varchar2,
  old_password varchar2)
  RETURN boolean IS 
   n boolean;
   m integer;
   differ integer;
   isdigit boolean;
   ischar  boolean;
   ispunct boolean;
   digitarray varchar2(20);
   punctarray varchar2(25);
   chararray varchar2(52);

BEGIN 
   digitarray:= '0123456789';
   chararray:= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   punctarray:='!"#$%&()``*+,-/:;<=>?_';

   -- Check if the password is same as the username
   IF NLS_LOWER(password) = NLS_LOWER(username) THEN
     raise_application_error(-20001, 'Password same as or similar to user');
   END IF;

   -- Check for the minimum length of the password
   IF length(password) < 4 THEN
      raise_application_error(-20002, 'Password length less than 4');
   END IF;

   -- Check if the password is too simple. A dictionary of words may be
   -- maintained and a check may be made so as not to allow the words
   -- that are too simple for the password.
   IF NLS_LOWER(password) IN ('bovespa1','bovespa12','bovespa13','bovespa14','bovespa2012','bovespa2013','bovespa2014', 
                              'oracle1','oracle12','oracle13','oracle14','oracle2012','oracle2013','oracle2014', 
                              'welcome1', 'database1', 'account1', 'user1234', 'password1', 'oracle123', 'computer1', 'abcdefg1', 'change_on_install') THEN
      raise_application_error(-20002, 'Password too simple');
   END IF;

   -- Check if the password contains at least one letter, one digit and one
   -- punctuation mark.
   -- 1. Check for the digit
   isdigit:=FALSE;
   m := length(password);
   FOR i IN 1..10 LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(digitarray,i,1) THEN
            isdigit:=TRUE;
             GOTO findchar;
         END IF;
      END LOOP;
   END LOOP;
   IF isdigit = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least one digit, one character and one punctuation');
   END IF;
   -- 2. Check for the character
   <<findchar>>
   ischar:=FALSE;
   FOR i IN 1..length(chararray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(chararray,i,1) THEN
            ischar:=TRUE;
             GOTO findpunct;
         END IF;
      END LOOP;
   END LOOP;
   IF ischar = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least one \
              digit, one character and one punctuation');
   END IF;
   -- 3. Check for the punctuation
   <<findpunct>>
   ispunct:=FALSE;
   FOR i IN 1..length(punctarray) LOOP 
      FOR j IN 1..m LOOP 
         IF substr(password,j,1) = substr(punctarray,i,1) THEN
            ispunct:=TRUE;
             GOTO endsearch;
         END IF;
      END LOOP;
   END LOOP;
   IF ispunct = FALSE THEN
      raise_application_error(-20003, 'Password should contain at least one \
              digit, one character and one punctuation');
   END IF;

   <<endsearch>>
   -- Check if the password differs from the previous password by at least
   -- 3 letters
   IF old_password IS NOT NULL THEN
     differ := length(old_password) - length(password);

     IF abs(differ) < 3 THEN
       IF length(password) < length(old_password) THEN
         m := length(password);
       ELSE
         m := length(old_password);
       END IF;

       differ := abs(differ);
       FOR i IN 1..m LOOP
         IF substr(password,i,1) != substr(old_password,i,1) THEN
           differ := differ + 1;
         END IF;
       END LOOP;

       IF differ < 3 THEN
         raise_application_error(-20004, 'Password should differ by at \
         least 3 characters');
       END IF;
     END IF;
   END IF;
   -- Everything is fine; return TRUE ;   
   RETURN(TRUE);
END;
/

-- This script alters the default parameters for Password Management
-- This means that all the users on the system have Password Management
-- enabled and set to the following values unless another profile is 
-- created with parameter values set to different value or UNLIMITED 
-- is created and assigned to the user.

Rem    ============================================================================================

Rem    PAR�METROS M�NIMOS EXIGIDOS PELA AUDITORIA (Rodrigo De Carvalho Correia em 31/10/2011 10:25)
Rem      Tamanho m�nimo	8 caracteres
Rem      Exig�ncia de complexidade de senha	SIM
Rem      Hist�rico de senhas	12 �ltimas
Rem      Per�odo de expira��o de senhas	90 dias (exceto contas de servi�o)
Rem      Bloqueio ap�s tentativas inv�lidas	5 tentativas

Rem    ============================================================================================


Prompt Alterando profile DEFAULT:
Prompt ==========================

---------------------------------------
-- PROFILE DEFAULT = Contas de Usu�rios
---------------------------------------

ALTER PROFILE DEFAULT LIMIT
PASSWORD_LIFE_TIME 90
PASSWORD_GRACE_TIME 7
PASSWORD_REUSE_TIME 30
PASSWORD_REUSE_MAX 12
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LOCK_TIME 1
PASSWORD_VERIFY_FUNCTION verify_function;



Prompt Criando profile SERVICO:
Prompt ==========================

----------------------------------------------------------------------
-- PROFILE SERVICO = Contas de Servico inclu�ndo contas do Oracle.
-- ATEN��O : N�o esque�a que a conta SYS e SYSTEM deve ficar neste profile.
--           Isto � feito automaticamente mais abaixo.
-----------------------------------------------------------------------

CREATE PROFILE SERVICO LIMIT
PASSWORD_LIFE_TIME UNLIMITED    -- N�O EXPIRA PARA CONTAS DE SERVI�O
PASSWORD_GRACE_TIME 7
PASSWORD_REUSE_TIME 30
PASSWORD_REUSE_MAX 12
FAILED_LOGIN_ATTEMPTS UNLIMITED
PASSWORD_LOCK_TIME 1
PASSWORD_VERIFY_FUNCTION verify_function;



Prompt
Prompt
Prompt AGORA, POR SEGURAN�A, TODOS OS USU�RIOS SER�O COLOCADOS NO PROFILE DA CONTA DE SERVI�O!!!
Prompt Ap�s isso, voc� deve mudar manualmente as contas de usu�rios para o profile Default.
Prompt
prompt Pressione qualquer tecla para continuar ou <Ctrl+C> para cancelar
accept v_owner char Prompt "========================================================================================="

set head off
set pages 1000
set lines 200
spool utlpwdmg10g.txt
SELECT 'ALTER USER '|| USERNAME ||' PROFILE SERVICO;' FROM DBA_USERS
WHERE USERNAME <> 'XS$NULL'
AND PROFILE = 'DEFAULT';
spool off
@utlpwdmg10g.txt
Prompt
Prompt Usu�rio XS$NULL fica inalterado por restri��es.
Prompt Agora vc deve manualmente mover as contas de usu�rio nomeado para o profile default.
Prompt ====================================================================================
