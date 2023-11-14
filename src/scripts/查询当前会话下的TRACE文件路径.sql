SELECT D.VALUE || '/' || LOWER(RTRIM(I.INSTANCE, CHR(0))) || '_ora_' ||
       P.SPID || '.trc' TRACE_FILE_NAME
  FROM (SELECT P.SPID
          FROM V$MYSTAT M, V$SESSION S, V$PROCESS P
         WHERE M.STATISTIC# = 1
           AND S.SID = M.SID
           AND P.ADDR = S.PADDR) P,
       (SELECT /*+no_merge(v)*/
         T.INSTANCE
          FROM V$THREAD T, V$PARAMETER V
         WHERE V.NAME = 'thread'
           AND (V.VALUE = 0 OR T.THREAD# = TO_NUMBER(V.VALUE))) I,
       (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'user_dump_dest') D;
