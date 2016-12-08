DECLARE
  l_namespace   VARCHAR2(240) := 'http://www.oracle-base.com/webservices/';
  l_xmltype_in  XMLTYPE;
  l_xmltype_out XMLTYPE;

  init_succeed  BOOLEAN;
BEGIN
  -- 初始化web service
  init_succeed :=
  cux_dbws_helper.init_service(
                    p_namespace   => l_namespace
                  , p_serive_name => 'Calculator'
                  , p_port_name   => 'CalculatorPort'
                  , p_wsdl_uri    => 'http://www.oracle-base.com/webservices/server.php?wsdl'
                  );

  IF init_succeed THEN
    -- 设定参数
    l_xmltype_in := SYS.XMLTYPE('<?xml version="1.0" encoding="utf-8"?>
      <ws_add xmlns="' || l_namespace || '">
        <int1>' || &p_int_1 || '</int1>
        <int2>' || &p_int_2 || '</int2>
      </ws_add>');
    -- 调用方法
    l_xmltype_out := cux_dbws_helper.invoke_operation(
                                       p_operation_name => 'ws_add'
                                     , p_request_params => l_xmltype_in
                                     );
    -- 释放服务
    cux_dbws_helper.release_service();

    -- 输出结果
    dbms_output.put_line('Result: ' || l_xmltype_out.extract('//return/text()').getNumberVal());
  ELSE
    dbms_output.put_line('Result: ' || 'Init failed');
  END IF;
END;
