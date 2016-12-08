-- �鿴��ռ�ʹ�����
SELECT UPPER(F.TABLESPACE_NAME) "��ռ���",
       D.TOT_GROOTTE_MB "��ռ��С(M)",
       D.TOT_GROOTTE_MB - F.TOTAL_BYTES "��ʹ�ÿռ�(M)",
       TO_CHAR(ROUND((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) /
                     D.TOT_GROOTTE_MB * 100,
                     2),
               '990.99') || '%' "ʹ�ñ�",
       F.TOTAL_BYTES "���пռ�(M)",
       F.MAX_BYTES "����(M)"
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

--��ѯ��ռ��free space
select tablespace_name,
       count(*) AS extends,
       round(SUM(bytes) / 1024 / 1024,2) AS MB,
       sum(blocks) AS blocks
  from dba_free_space
 group BY tablespace_name;
;

-- ��ѯ��ռ�Ĵ�С
select tablespace_name, sum(bytes) / 1024 / 1024 as MB
����from dba_data_files
����group by tablespace_name;
