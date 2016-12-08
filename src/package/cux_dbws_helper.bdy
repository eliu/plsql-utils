CREATE OR REPLACE PACKAGE BODY CUX_DBWS_HELPER
AS

--
-- 全局变量声明
--
g_NAMESPACE        VARCHAR2(240);            -- web service所使用的命名空间
g_SERVICE_QNAME    utl_dbws.QNAME;           -- 服务名称
g_PORT_QNAME       utl_dbws.QNAME;           -- 服务端口名称
g_WSDL_HTTP_URI    HTTPURITYPE;              -- 服务的http地址
--g_OPERATION_STYLE  VARCHAR2(30)    := 'rpc'; -- 调用服务方法的样式
-- 可选择的服务方法: rpc 或者 document
-- rpc     : 通过基本类型来接收和发送数据
-- document: 通过xml片段来接收和发送数据
g_SERVICE          utl_dbws.SERVICE;         -- web services 实体

g_INIT_STATUS      VARCHAR2(1) := INIT_NEW; -- 初始化状态

FUNCTION init_service(
           p_namespace   IN VARCHAR2
         , p_serive_name IN VARCHAR2
         , p_port_name   IN VARCHAR2
         , p_wsdl_uri    IN VARCHAR2
) RETURN BOOLEAN IS
BEGIN
  -- 初始化为成功
  g_INIT_STATUS   := INIT_SUCCESS;

  -- 初始化web服务参数
  g_NAMESPACE     := p_namespace;
  g_SERVICE_QNAME := utl_dbws.to_qname(g_NAMESPACE, p_serive_name);
  g_PORT_QNAME    := utl_dbws.to_QName(g_NAMESPACE, p_port_name);
  g_WSDL_HTTP_URI := HttpUriType(p_wsdl_uri);

  -- 启动连接web服务
  g_SERVICE := utl_dbws.Create_Service(
                    wsdl_Document_Location => g_WSDL_HTTP_URI
                  , service_Name           => g_SERVICE_QNAME
                  );

  RETURN (TRUE);
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Init service failed: ' || chr(10) || SQLERRM);
    g_INIT_STATUS := INIT_FAILURE;
    RETURN (FALSE);
END init_service;

PROCEDURE release_service IS
BEGIN
  IF g_SERVICE IS NOT NULL THEN
    utl_dbws.release_service(g_SERVICE);
    g_SERVICE := NULL; -- BUG000001
  END IF;
END release_service;

-- 将参数列表转换成内部参数列表对象
FUNCTION to_Anydata_List(
           p_call       IN utl_dbws.CALL
         , p_param_list IN WS_PARAMETER_TBL_TYPE)
RETURN utl_dbws.ANYDATA_LIST IS
  x_ret_list utl_dbws.ANYDATA_LIST;
BEGIN
  FOR i IN 1..p_param_list.Count LOOP
    utl_dbws.Add_Parameter(
               call_Handle => p_call
             , xml_name    => p_param_list(i).NAME
             , q_name      => p_param_list(i).DATA_TYPE
             , p_mode      => p_param_list(i).PARAM_MODE
             );

    IF p_param_list(i).DATA_TYPE = WS_INT_TYPE THEN
      x_ret_list(i) := AnyData.ConvertNumber(p_param_list(i).VALUE.accessNumber);
    ELSIF p_param_list(i).DATA_TYPE = WS_STRING_TYPE THEN
      x_ret_list(i) := AnyData.ConvertVarchar2(p_param_list(i).VALUE.accessVarchar2);
    END IF;
  END LOOP;

  -- add return type
  utl_dbws.Set_Return_Type(
             call_Handle => p_call
           , ret_type    => WS_STRING_TYPE);

  RETURN x_ret_list;
END to_Anydata_List;

FUNCTION wrap_xml_with(
           p_root_element  IN VARCHAR2
         , p_xml_frgmt     IN VARCHAR2
) RETURN VARCHAR2 IS
  ROOT_EL_NAME CONSTANT VARCHAR2(10) := NVL(p_root_element, 'ROOT');
  l_xml_body   VARCHAR2(32767);
  l_xml_header VARCHAR2(50);
BEGIN
    SELECT SUBSTR(p_xml_frgmt,1, INSTR(p_xml_frgmt, '?>', 1) + 1),
           SUBSTR(p_xml_frgmt, INSTR(p_xml_frgmt, '?>', 1) + 2)
      INTO l_xml_header, l_xml_body
      FROM dual;

    RETURN l_xml_header || '<'||ROOT_EL_NAME||'>' || l_xml_body || '</'||ROOT_EL_NAME||'>';
END wrap_xml_with;

-- 检查给定的operation是否在当前web服务的操作列表中
FUNCTION operation_exists(
           p_op_qname IN utl_dbws.QNAME
) RETURN BOOLEAN
IS
  v_op_list          utl_dbws.QNAME_LIST;
BEGIN

  dbms_output.put_line('Call function utl_dbws.get_operations...');
  v_op_list  := utl_dbws.Get_Operations(g_SERVICE, g_PORT_QNAME);

  -- 迭代当前web服务下所有的操作方法
  dbms_output.put_line('Find specified operation name...');
  FOR i IN v_op_list.first..v_op_list.last LOOP
    IF p_op_qname = v_op_list(i) THEN
      RETURN (TRUE);
    END IF;
  END LOOP;


  RETURN (FALSE);
END operation_exists;

FUNCTION invoke_operation(
           p_operation_name IN VARCHAR2
         , p_request_params IN WS_PARAMETER_TBL_TYPE
) RETURN AnyData IS

  v_call          utl_dbws.CALL;
  v_op_qname      utl_dbws.QNAME;

  x_response_data AnyData;

BEGIN
  -- 检查创建并调用operation的必要性条件
  IF( g_SERVICE IS NULL ) THEN
    RETURN NULL;
  END IF;

  -- 检查给定的operation是否在当前web服务的操作列表中
  IF NOT operation_exists(p_operation_name) THEN
    RETURN NULL;
  END IF;

  -- 调用dbws API创建operation
  v_call := utl_dbws.Create_Call(g_SERVICE, g_PORT_QNAME, v_op_qname);

  -- 设置operation的属性
  utl_dbws.Set_Property(v_call, 'SOAPACTION_USE'   , 'TRUE');
  utl_dbws.Set_Property(v_call, 'SOAPACTION_URI'   , 'urn:' || p_operation_name);
  utl_dbws.Set_Property(v_call, 'ENCODINGSTYLE_URI', 'http://schemas.xmlsoap.org/soap/encoding/');
  utl_dbws.Set_Property(v_call, 'OPERATION_STYLE'  , OP_STYLE_DOC);

  -- invoke operation
  x_response_data := utl_dbws.Invoke(v_call, to_Anydata_List(v_call, p_request_params));
  -- release call
  utl_dbws.Release_Call(v_call);

  RETURN (x_response_data);
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    RETURN (NULL);
END invoke_operation;

FUNCTION invoke_operation(
           p_operation_name IN VARCHAR2
         , p_request_params IN XMLTYPE
) RETURN XMLTYPE IS

  v_call          utl_dbws.CALL;
  v_op_qname      utl_dbws.QNAME;

  x_response_data XMLTYPE;

BEGIN
  -- 检查创建并调用operation的必要性条件
  dbms_output.put_line('check service...');
  IF( g_SERVICE IS NULL ) THEN
    RETURN NULL;
  END IF;

  v_op_qname := utl_dbws.to_QName(g_namespace, p_operation_name);

  -- 检查给定的operation是否在当前web服务的操作列表中
  dbms_output.put_line('Call function operation_exists...');
  IF NOT operation_exists(v_op_qname) THEN
    RETURN NULL;
  END IF;

  -- 调用dbws API创建operation
  dbms_output.put_line('Call function utl_dbws.Create_Call...');
  v_call := utl_dbws.Create_Call(
                       service_handle => g_SERVICE
                     , port_name      => g_PORT_QNAME
                     , operation_name => v_op_qname
                     );

  -- 调用操作方法
  dbms_output.put_line('Call function utl_dbws.Invoke...');
  x_response_data := utl_dbws.Invoke(
                                call_Handle => v_call
                              , request     => p_request_params);
  -- 释放操作方法
  dbms_output.put_line('Call procedure utl_dbws.Release_Call...');
  utl_dbws.Release_Call(v_call);

  RETURN (x_response_data);
END invoke_operation;

PROCEDURE add_param(
           p_param_list IN OUT NOCOPY WS_PARAMETER_TBL_TYPE
         , p_param_name IN VARCHAR2
         , p_value      IN VARCHAR2
         , p_mode       IN utl_dbws.QNAME
) IS
BEGIN
  p_param_list.Extend();
  p_param_list(p_param_list.Count).Name       := p_param_name;
  p_param_list(p_param_list.Count).Value      := AnyData.ConvertVarchar2(p_value);
  p_param_list(p_param_list.Count).Data_Type  := WS_STRING_TYPE;
  p_param_list(p_param_list.Count).Param_Mode := p_mode;
END add_param;

PROCEDURE add_param(
           p_param_list IN OUT NOCOPY WS_PARAMETER_TBL_TYPE
         , p_param_name IN VARCHAR2
         , p_value      IN NUMBER
         , p_mode       IN utl_dbws.QNAME
) IS
BEGIN
  p_param_list.Extend();
  p_param_list(p_param_list.Count).Name       := p_param_name;
  p_param_list(p_param_list.Count).Value      := AnyData.ConvertNumber(p_value);
  p_param_list(p_param_list.Count).Data_Type  := WS_INT_TYPE;
  p_param_list(p_param_list.Count).Param_Mode := p_mode;
END add_param;

FUNCTION to_XML(
           p_xml_frgmt IN VARCHAR2
         , x_ret_extra_node OUT NOCOPY VARCHAR2)
RETURN XMLTYPE IS
  ROOT_NODE CONSTANT VARCHAR2(10) := 'ROOT';
BEGIN
  x_ret_extra_node := '';
  RETURN (xmltype.createXML(p_xml_frgmt));
EXCEPTION
  WHEN OTHERS THEN
    IF( SQLCODE = '-31011' AND
        INSTR('LPX-00245', SQLERRM) >= 0 ) THEN
      x_ret_extra_node := '/' || ROOT_NODE;
      RETURN (xmltype.createXML(
                        wrap_xml_with(p_root_element => ROOT_NODE
                                     ,p_xml_frgmt    => p_xml_frgmt)
                      )
             );
    ELSE
      RAISE;
    END IF;
END to_XML;

END CUX_DBWS_HELPER;
/
