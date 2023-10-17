rem -----------------------------------------------------------------------
rem Name  : baseline_drop.sql
rem Author: gmonteiro
rem Date  : 04/01/2018
rem Desc  : Deleta baselines
rem -----------------------------------------------------------------------

accept sql_handle prompt 'Input sql_handle: '

PROMPT 
PROMPT ===========================================================================================
PROMPT BMS_SPM.DROP_SQL_PLAN_BASELINE (DROPA BASELINE)
PROMPT ===========================================================================================

DECLARE
  v_dropped_plans number;
BEGIN
  v_dropped_plans := DBMS_SPM.DROP_SQL_PLAN_BASELINE (
     sql_handle => '&sql_handle'
);
  DBMS_OUTPUT.PUT_LINE('dropped ' || v_dropped_plans || ' plans');
END;
/