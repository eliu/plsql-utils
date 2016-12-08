-- 查看表空间使用情况
SELECT UPPER(F.TABLESPACE_NAME) "表空间名",
       D.TOT_GROOTTE_MB "表空间大小(M)",
       D.TOT_GROOTTE_MB - F.TOTAL_BYTES "已使用空间(M)",
       TO_CHAR(ROUND((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) /
                     D.TOT_GROOTTE_MB * 100,
                     2),
               '990.99') || '%' "使用比",
       F.TOTAL_BYTES "空闲空间(M)",
       F.MAX_BYTES "最大块(M)"
  FROM (SELECT TABLESPACE_NAME,
               ROUND(SUM(BYTES) / (1024 * 1024), 2) TOTAL_BYTES,
               ROUND(MAX(BYTES) / (1024 * 1024), 2) MAX_BYTES
          FROM SYS.DBA_FREE_SPACE
         GROUP BY TABLESPACE_NAME) F,
       (SELECT DD.TABLESPACE_NAME,
               ROUND(SUM(DD.BYTES) / (1024 * 1024), 2) TOT_GROOTTE_MB
          FROM SYS.DBA_DATA_FILES DD
         GROUP BY DD.TABLESPACE_NAME) D
 WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME
 ORDER BY 1;

--查询表空间的free space
select tablespace_name,
       count(*) AS extends,
       round(SUM(bytes) / 1024 / 1024,2) AS MB,
       sum(blocks) AS blocks
  from dba_free_space
 group BY tablespace_name;
;

-- 查询表空间的大小
select tablespace_name, sum(bytes) / 1024 / 1024 as MB
　　from dba_data_files
　　group by tablespace_name;
