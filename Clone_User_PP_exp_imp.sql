--Export
Req:xxxxxxxxx
Usuario Origem: UAT301MIOO

---Efetuar logon no servidor e identificar o fs que será utilizado para armazenar os arquivos de backup
df -h 
cd .....

--Criar o shell script
vi ExecExpdp.sh

#!/bin/bash

# Executa export schema

#variavel
servidor=`hostname -a`
data=`date +"%d-%m-%Y"`
diretorio=$1
user='"/ as sysdba"'
schema=$2
logfile=LOGExp$schema.log

if [ -z "$diretorio" ]; then
	echo
    echo INFO....: Variável "'"diretório"'" ou "'"schema"'" não declarada.
	echo INFO....: Exemplo: sh ExecExpdp.sh /opt/oracle/kl UAT301MIOO
	echo
	exit;
elif [ -z "$schema" ]; then
	echo
    echo INFO....: Variável "'"diretório"'" ou "'"schema"'" não declarada.
	echo INFO....: Exemplo: sh ExecExpdp.sh /opt/oracle/kl UAT301MIOO
	echo
	exit;
else
    echo ' ' 
fi

echo
echo ---Export Schema Oracle
echo Servidor..: $servidor
echo Data......: $data
echo Diretorio.: $diretorio
echo SchemaOrig: $schema
echo Log.......: $logfile
echo

sleep 5

sqlplus -S "/ as sysdba" << EOF
create or replace directory DIRDUMPCLONE as '$diretorio';
exit;
EOF

expdp userid=$user dumpfile=DMP_${schema}_%U.dmp logfile=$logfile content=all schemas=$schema directory=DIRDUMPCLONE parallel=2 cluster=n

--Execução:
                 DiretorioDump  Usuario
sh ExecExpdp.sh /opt/oracle/kl  UAT301MIOO

Efetuar a transferência do Dump para o servidor Destino conforme descrito na req.

..............................................................................................
IMPORT
usuarios a serem criados - CA01MIOO
usuarios a serem criados - CA01MIOU

--Criar tablespace com base na origem, identificar as tablespaces utilizadas pelo usuário no banco de origem e criar igual no destino
create tablespace MIO_INDEX      datafile '+DATADG' size 5000M autoextend on next 1000M  maxsize 32000M;
create tablespace MIO_DATA_UAT3  datafile '+DATADG' size 5000M autoextend on next 1000M  maxsize 32000M;
create tablespace MIO_INDEX_UAT3 datafile '+DATADG' size 1000M autoextend on next 1000M  maxsize 32000M;

--Criar roles para o novo usuário
create role CA01MIOEX;
create role CA01MIORW;
create role CA01MIORO;

--Criar novos usuários
CREATE USER "CA01MIOO" IDENTIFIED BY <senha>
DEFAULT TABLESPACE "MIO_DATA"
TEMPORARY TABLESPACE "TEMP";

GRANT "CA01MIOEX" TO "CA01MIOO";
GRANT "CA01MIORW" TO "CA01MIOO";
GRANT "CA01MIORO" TO "CA01MIOO";
GRANT CREATE SYNONYM TO "CA01MIOO";
GRANT CREATE SESSION TO "CA01MIOO";
ALTER USER "CA01MIOO" DEFAULT ROLE ALL;

CREATE USER "CA01MIOU" IDENTIFIED BY <senha>
DEFAULT TABLESPACE "MIO_DATA"
TEMPORARY TABLESPACE "TEMP";

GRANT "CA01MIOEX" TO "CA01MIOU";
GRANT "CA01MIORW" TO "CA01MIOU";
GRANT "CA01MIORO" TO "CA01MIOU";
GRANT CREATE SYNONYM TO "CA01MIOU";
GRANT CREATE SESSION TO "CA01MIOU";
ALTER USER "CA01MIOU" DEFAULT ROLE ALL;

--Importar os dados
vi ExecImpdp.sh

# Executa import schema

#variavel
servidor=`hostname -a`
data=`date +"%d-%m-%Y"`
diretorio=$1
user='"/ as sysdba"'
schemaorigem=$2
schemadestino=$3
logfile=LOGImp$schemadestino.log
#dump=DMP_$schema

if [ -z "$diretorio" ]; then
	echo
    echo INFO....: Variável "'"diretório"'", "'"schemaorigem"'" ou "'"schemadestino"'"  não declarada.
	echo INFO....: Exemplo: sh ExecImpdp.sh /opt/oracle/kl  UAT301MIOO   CA01MIOO
	echo
	exit;
elif [ -z "$schemaorigem" ]; then
	echo
    echo INFO....: Variável "'"diretório"'", "'"schemaorigem"'" ou "'"schemadestino"'"  não declarada.
	echo INFO....: Exemplo: sh ExecImpdp.sh /opt/oracle/kl  UAT301MIOO   CA01MIOO
	echo
	exit;
elif [ -z "$schemadestino" ]; then
	echo
    echo INFO....: Variável "'"diretório"'", "'"schemaorigem"'" ou "'"schemadestino"'"  não declarada.
	echo INFO....: Exemplo: sh ExecImpdp.sh /opt/oracle/kl  UAT301MIOO   CA01MIOO
	echo
	exit;
else
    echo ' ' 
fi

echo
echo ---Import Schema Oracle
echo Servidor..: $servidor
echo Data......: $data
echo Diretorio.: $diretorio
echo SchemaOrig: $schemaorigem
echo SchemaDest: $schemadestino
echo Log.......: $logfile
#echo Dumpfile..: $dump
echo

sleep 5

sqlplus -S "/ as sysdba" << EOF
create or replace directory DIRDUMPCLONE as '$diretorio';
exit;
EOF

impdp userid=$user dumpfile=DMP_${schemaorigem}_%U.dmp logfile=$logfile content=all schemas=$schemaorigem directory=DIRDUMPCLONE cluster=n remap_schema=${schemaorigem}:${schemadestino} EXCLUDE=GRANT

                 diretorio Dump User Origem  User Destino
sh ExecImpdp.sh /opt/oracle/kl  UAT301MIOO   CA01MIOO

--Conceder grant para o usuario ao final
set serveroutput on
exec sys.DS_CS_GR_SCHEMAS ( 'CA01MIOO' , 'CA01MIOU', 'CA01MIOEX', 'CA01MIORW', 'CA01MIORO' );


