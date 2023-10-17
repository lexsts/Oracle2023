SET lines 150
SET pages 500
SET feed ON
SET HEAD OFF
SET verify OFF
COL message_text FOR a150
COL ORIGINATING_TIMESTAMP FOR A38

SELECT 'DATA/HORA:'||'    = '||originating_timestamp||Chr(10)||
        'IP ADDRESS:'||'    = '||HOST_ADDRESS||Chr(10)||
        'MSG ERROR: ' ||'    = '||message_text||Chr(10)||
        'MSG ARGS: '  ||'     = '||MESSAGE_ARGUMENTS||Chr(10)||
        'SUPPL DETAILS:'||' = '||SUPPLEMENTAL_DETAILS
FROM sys.X$DBGALERTEXT
    WHERE originating_timestamp > (SYSDATE-5/1440)
    AND (MESSAGE_TEXT like '%ORA-%'
        or upper(MESSAGE_TEXT) like '%ERROR%'
        or upper(MESSAGE_TEXT) like '%FATAL%'
        or upper(MESSAGE_TEXT) like '%TNS%')
 ORDER BY originating_timestamp;