-- 本脚本可用于诊断"ORA-01000: maximum open cursors exceeded"
-- 异常。这种异常通常是由于Java应用程序调用JDBC是未能及时关闭游标所致。
-- createStatement/preparedStatement/ResultSet等等都会打开一个游标。
--
-- 查询打开游标最多的会中执行次数最多的(pl)sql语句
--
SELECT *
  FROM (SELECT oc.SID,
               oc.user_name,
               ss.osuser,
               count(*) AS sql_freq,
               sa.sql_text
          FROM gv$open_cursor oc, gv$session ss,gv$sqlarea sa
         WHERE oc.SID = ss.SID
           AND oc.sql_id = sa.sql_id
         GROUP BY oc.SID,
                  oc.user_name,
                  ss.osuser,
                  sa.sql_text
         ORDER BY sql_freq DESC)
 WHERE ROWNUM <= 5;
