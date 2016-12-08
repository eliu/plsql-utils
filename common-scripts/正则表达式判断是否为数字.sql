-- Data source begin
WITH data_source AS (
SELECT '1' number_like_string  FROM DUAL    -- good
UNION ALL
SELECT '100.4'     FROM DUAL  -- good
UNION ALL
SELECT '-100.4'    FROM DUAL  -- good
UNION ALL
SELECT '.1234'     FROM DUAL  -- good
UNION ALL
SELECT '-.1234'    FROM DUAL  -- good
UNION ALL
SELECT '1234.'     FROM DUAL  -- good
UNION ALL
SELECT '+1234.56'  FROM DUAL  -- good
UNION ALL
SELECT 'ABC'       FROM DUAL  -- NG
UNION ALL
SELECT '234234ABC' FROM DUAL  -- NG
UNION ALL
SELECT '.'     FROM DUAL)     -- NG
-- Data source end
SELECT ds.number_like_string,
       decode(regexp_substr(ds.number_like_string,'^[\.\+-]?((\d+(\.\d*)?)|(\d*\.\d+))$'),
              null, 'NG!', 'Good') MATCHED_RESULT
  FROM data_source ds;
/*
+=================+
| Expected Result |
+=================+
NUMBER_LI MATC
--------- ----
1         Good
100.4     Good
-100.4    Good
.1234     Good
-.1234    Good
1234.     Good
+1234.56  Good
ABC       NG!
234234ABC NG!
.         NG!

已选择 10 行。

SQL>
*/
