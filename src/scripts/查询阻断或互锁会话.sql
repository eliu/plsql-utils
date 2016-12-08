SELECT /*+ordered */
 l1.ctime AS h_time
,l2.ctime AS w_time
,s1.username || '/' || s1.machine || ':' || s1.process || ' ( ' || s1.sid || ',' || s1.serial# || ',@' || s1.inst_id ||
 ')  is blocking ' || s2.username || '/' || s2.machine || ' ( ' || s2.sid || ',' || s2.serial# || ',@' || s2.inst_id || ') ' AS blocking_status
,s1.status AS h_status
,s1.action AS h_action
,s1.sql_id AS h_sqlid
,s2.action AS w_action
,s1.module AS h_module
,s2.module AS w_module
FROM   gv$lock    l1
      ,gv$session s1
      ,gv$lock    l2
      ,gv$session s2
WHERE  s1.inst_id = l1.inst_id
AND    s1.sid = l1.sid
AND    s2.inst_id = l2.inst_id
AND    s2.sid = l2.sid
AND    l1.block = 1
AND    l2.request > 0
AND    l1.id1 = l2.id1
AND    l1.id2 = l2.id2
ORDER  BY l1.ctime DESC;
