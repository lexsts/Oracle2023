--10g Release 2 (and previous versions) get 10g password hashes:
SELECT username, password FROM dba_users WHERE username='<username>';

--11g Release 1 (and later versions) get both 10g and 11g password hashes:
SELECT name, password, spare4 FROM sys.user$ WHERE name='<username>';


--Changing a password hash (version dependent)
--10g Release 2 (and previous versions)
ALTER USER username IDENTIFIED BY VALUES '<10g password hash>';

--11g Release 1 (and later versions)
ALTER USER username IDENTIFIED BY VALUES '<11g password hash>';






--PROFILE
alter user zz profile abc;

select * from dba_profiles where profile='DEFAULT'
alter profile DBUSER limit PASSWORD_REUSE_TIME UNLIMITED;

alter user PR01RPWO profile DEFAULT;

alter profile DEFAULT limit PASSWORD_REUSE_MAX UNLIMITED;

