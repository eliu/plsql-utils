DECLARE

  l_clob         CLOB;

  CURSOR cur_view IS
    SELECT 'VIEW' object_type,
           av.owner,
           av.view_name
      FROM DBA_VIEWS av
     WHERE 1 = 1
       AND (av.view_name  LIKE 'CUX%' OR av.view_name  LIKE 'GT%' OR av.view_name  LIKE 'GITI%')
    UNION ALL
    SELECT 'MATERIALIZED_VIEW' object_type,
           mv.owner, mv.mview_name view_name 
     FROM dba_mviews mv
    WHERE 1 = 1
      AND (mv.mview_name  LIKE 'CUX%' OR mv.mview_name  LIKE 'GT%' OR mv.mview_name  LIKE 'GITI%');
BEGIN

  FOR l_view IN cur_view LOOP
  
    l_clob   := dbms_metadata.get_ddl(object_type => l_view.object_type,
                                      NAME        => l_view.view_name,
                                      SCHEMA      => l_view.owner);


    IF dbms_lob.instr(UPPER(l_clob), 'US_ERP_CHN_ERP_PROD.GITITIREUSA.COM') > 0 THEN
       dbms_output.put_line(l_view.owner || '.' || l_view.view_name);
    END IF;
    
    IF dbms_lob.instr(UPPER(l_clob), 'GT_US_CN_PROD.WORLD') > 0 THEN
       dbms_output.put_line(l_view.owner || '.' || l_view.view_name);
    END IF;

  END LOOP;

END;
/
