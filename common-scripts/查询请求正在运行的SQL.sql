SELECT to_char(s.sid) || ',' || to_char(s.serial#),
       sql_text
  FROM applsys.fnd_concurrent_requests r,
       v$process                       p,
       v$session                       s,
       v$sqltext_with_newlines         sqlt
 WHERE r.oracle_process_id = p.spid
   AND p.addr = s.paddr(+)
   AND s.sql_address = sqlt.address(+)
   AND s.sql_hash_value = sqlt.hash_value(+)
   AND r.request_id = 18110580 --&request_id
 ORDER BY piece;