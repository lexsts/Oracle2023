
--LOCALIZA AS TRANSACTIONS
select * from dba_2pc_pending;

--COMMIT OR ROLLBACK THE TRANSACTION

  --commit: 

    commit force '<local_tran_id>'; 

  --rollback: 

    rollback force '<local_tran_id>'; 

  --clear:
    exec dbms_transaction.purge_lost_db_entry('<local_tran_id>');
	
	
	
	
--------------------------------------------------------------
Problem Description:
====================

It sometimes becomes necessary to cleanup failed distributed transactions.  
This could be due to an error message flooding the alert log showing a local 
transaction ID.  The error messages may be found in the alert.log, trace files
and you may even get them on a startup of the database.

The error messages could include, but are not limited to, the 
following: 

    ORA-02019: "connection description for remote database not found" 
        Cause: The user attempted to connect or log in to a remote 
              database using a connection description that could not 
              be found. 
      Action: Specify an existing database link.  Query the data 
              dictionary to see all existing database links.  See  
              your operating system-specific SQL*Net documentation 
              for valid connection descriptors. 

    ORA-02058: "no prepared transaction found with ID %s" 
        Cause: A COMMIT FORCE was attempted on a transaction, but the 
              transaction with LOCAL_TRAN_ID or GLOBAL_TRAN_ID was 
              not found in the DBA_2PC_INDOUBT table in prepared 
              state. 
      Action: Check the DBA_2PC_INDOUBT table to ensure the proper 
              transaction ID is used and attempt the commit again. 
    
    ORA-02068: "following severe error from %s%s 
        Cause: A severe error (disconnect, fatal Oracle error) received 
              from the indicated database link.  See following error 
              text. 
      Action: Contact the remote system administrator. 
  
    ORA-02050: "transaction %s rolled back, some remote DBs may be 
              in-doubt" 
        Cause: Network or remote failure in 2PC. 
      Action: Notify operations; remote DBs will automatically re-sync 
              when the failure is repaired. 


Problem Explanation:
====================
The following information comes from $ORACLE_HOME\rdbms\admin\dbmsutil.sql
which describes why Distributed Transactions can sometimes get into this state
and the action needed to take care of it.

procedure purge_lost_db_entry(xid varchar2);
  --  When a failure occurs during commit processing, automatic recovery will
  --    consistently resolve the results at all sites involved in the
  --    transaction.  However, if the remote database is destroyed or
  --    recreated before recovery completes, then the entries used to
  --    control recovery in DBA_2PC_PENDING and associated tables will never
  --    be removed, and recovery will periodically retry.  Procedure
  --    purge_lost_db_entry allows removal of such transactions from the
  --    local site.

  --  WARNING: purge_lost_db_entry should ONLY be used when the other
  --  database is lost or has been recreated.  Any other use may leave the
  --  other database in an unrecoverable or inconsistent state.

  --    Before automatic recovery runs, the transaction may show
  --    up in DBA_2PC_PENDING as state "collecting", "committed", or
  --    "prepared".  If the DBA has forced an in-doubt transaction to have
  --    a particular result by using "commit force" or "rollback force",      
  --    then states "forced commit" or "forced rollback" may also appear.
  --    Automatic recovery will normally delete entries in any of these
  --    states.  The only exception is when recovery finds a forced
  --    transaction which is in a state inconsistent with other sites in the
  --    transaction;  in this case, the entry will be left in the table
  --    and the MIXED column will have a value 'yes'.

  --    However, under certain conditions, it may not be possible for
  --    automatic recovery to run.  For example, a remote database may have
  --    been permanently lost.  Even if it is recreated, it will get a new
  --    database id, so that recovery cannot identify it (a possible symptom
  --    is ORA-02062).  In this case, the DBA may use the procedure
  --    purge_lost_db_entry to clean up the entries in any state other
  --    than "prepared".  The DBA does not need to be in any particular
  --    hurry to resolve these entries, since they will not be holding any
  --    database resources.

  --    The following table indicates what the various states indicate about
  --    the transaction and what the DBA actions should be:

  --    State      State of    State of    Normal Alternative
  --    Column      Global      Local        DBA    DBA
  --                Transaction  Transaction  Action Action
  --    ----------  ------------ ------------ ------ ---------------
  --    collecting  rolled back  rolled back  none  purge_lost_db_entry (1)
  --    committed  committed    committed    none  purge_lost_db_entry (1)
  --    prepared    unknown      prepared    none  force commit or rollback
  --    forced      unknown      committed    none  purge_lost_db_entry (1)
  --      commit
  --    forced      unknown      rolled back  none  purge_lost_db_entry (1)
  --      rollback
  --    forced      mixed        committed    (2)                              
  --      commit
  --      (mixed)
  --    forced      mixed        rolled back  (2)
  --      rollback
  --      (mixed)

  --    (1): Use only if significant reconfiguration has occurred so that
  --      automatic recovery cannot resolve the transaction.  Examples are
  --      total loss of the remote database, reconfiguration in software
  --      resulting in loss of two-phase commit capability, or loss of
  --      information from an external transaction coordinator such as a TP
  --      Monitor.
  --    (2): Examine and take any manual action to remove inconsistencies,
  --      then use the procedure purge_mixed.


Problem References:
===================

$ORACLE_HOME/rdbms/admin/dbmsutil.sql


Search Words:
=============

DISTRIBUTED DBA_2PC_PENDING STATUS REMOVE PURGE


Solution Description:
=====================

Before you begin, make note of the local transaction ID, <local_tran_id>, from 
the error message reported. 

1. Determine if you can attempt a commit or rollback of this 
  transaction.  You can do the following select to help determine what 
  action to take:

      SQL> select state, tran_comment, advice from dba_2pc_pending
              where local_tran_id = '<local_tran_id>';
        
Review the TRAN_COMMENT column as this could give more information 
as to the origin of the transaction or what type of transaction it was.

Review the ADVICE column as well.  Many applications prescribe advice 
about whether to force commit or force rollback the distributed 
transaction upon failure.

2. Commit or rollback the transaction.

  To commit: 

      SQL> commit force '<local_tran_id>'; 

  To rollback: 

      SQL> rollback force '<local_tran_id>'; 


WARNING: Step 3 (purge_lost_db_entry) and Step 4 should ONLY be used 
when the other database is lost or has been recreated.  
Any other use may leave the other database in an unrecoverable or 
inconsistent state.

3. If your are using release  7.3.x or greater and you need to execute 
purge_lost_db_entry from the suggestions above

  execute the following command in either Server Manager or SQL*Plus: 

  SQL> execute sys.dbms_transaction.purge_lost_db_entry('<local_tran_id>');

  SQL> COMMIT;

NOTE:  You must run above procedure as sys (since package is owned by sys),
      you must have execute privileges, or have DBA privileges


4. If running a release below 7.3 but were suggested to execute 
purge_lost_db_entry :

  Connect to Server Manager or SQL*Plus and execute the following  
  commands: 
      SQL> connect sys/<password>
      SQL> set transaction use rollback segment system; 
      SQL> delete from dba_2pc_pending where  
              local_tran_id = '<local_tran_id>'; 
      SQL> delete from pending_sessions$ where  
              local_tran_id = '<local_tran_id>'; 
      SQL> delete from pending_sub_sessions$ where  
              local_tran_id = '<local_tran_id>'; 
      SQL> COMMIT; 


Solution Explanation:
=====================
The above steps work ONLY after verifying that the other database
the Distributed Transaction is dependent on is no longer
available.  The steps above will allow these transactions
to be deleted and no longer cause RECO to keep giving you
the error messages stated in the problem.
------------------------------------------------------------------------------- 