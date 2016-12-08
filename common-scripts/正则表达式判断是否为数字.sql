-- Data source begin
WITH DATA_SOURCE AS (
SELECT '1' COL1  FROM DUAL
UNION ALL
SELECT 'ABC'       FROM DUAL
UNION ALL
SELECT '234234ABC' FROM DUAL
UNION ALL
SELECT '100.4'     FROM DUAL
UNION ALL
SELECT 'ABC'       FROM DUAL
UNION ALL
SELECT '-100.4'    FROM DUAL
UNION ALL
SELECT '.1234'     FROM DUAL
UNION ALL
SELECT '-.1234'    FROM DUAL
UNION ALL
SELECT '1234.'     FROM dual
UNION ALL
SELECT '.'     FROM DUAL)
-- Data source end
SELECT ds.col1,
       regexp_substr(ds.col1,'^[\.\+-]?((\d+(\.\d*)?)|(\d*\.\d+))$') col2
  FROM data_source ds
 WHERE REGEXP_SUBSTR(DS.COL1,'^[\.\+-]?((\d+(\.\d*)?)|(\d*\.\d+))$') IS NOT NULL
;
