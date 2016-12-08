CREATE OR REPLACE PACKAGE CUX_DBWS_HELPER
/* $Header: CUX_DBWS_HELPER.pck 1.0 2010/11/24 eric.liu noship $ */
/*==================================================
   Copyright (C) Hand Enterprise Solutions Co.,Ltd.
                All Rights Reserved
 ==================================================*/
/*==================================================
   Program Name:
      CUX_DBWS_HELPER
   Description:
      基于utl_dbws包基础上简化web service外部调用的工具包
   History:

      1.0  2010-11-24  eric.liu  Creation
 ==================================================*/
AS
  --
  -- 服务状态常量
  --
  INIT_NEW        CONSTANT BINARY_INTEGER := 0;
  INIT_FAILURE    CONSTANT BINARY_INTEGER := 1;
  INIT_SUCCESS    CONSTANT BINARY_INTEGER := 2;

  --
  -- Operation Styles
  --
  OP_STYLE_RPC    CONSTANT VARCHAR2(10)   := 'rpc';
  OP_STYLE_DOC    CONSTANT VARCHAR2(10)   := 'document';

  --
  -- 参数模式:输入/输出参数
  --
  PARAM_MODE_IN   CONSTANT VARCHAR2(30)   := 'ParameterMode.IN';
  PARAM_MODE_OUT  CONSTANT VARCHAR2(30)   := 'ParameterMode.OUT';

  --
  -- 参数类型
  --
  WS_INT_TYPE     CONSTANT utl_dbws.QNAME := utl_dbws.to_qname('http://www.w3.org/2001/XMLSchema', 'int');
  WS_STRING_TYPE  CONSTANT utl_dbws.QNAME := utl_dbws.to_qname('http://www.w3.org/2001/XMLSchema', 'string');

  --
  -- 传入OPERATION的参数集合类型，每一个参数均包含以下属性
  -- NAME       - 变量名称
  -- VALUE      - 参数值
  -- DATA_TYPE  - 数据类型
  -- PARAM_MODE - 传递模式（传入或传出）
  --
  TYPE WS_PARAMETER_REC_TYPE IS RECORD(
         NAME       VARCHAR(240)
       , VALUE      AnyData
       , DATA_TYPE  utl_dbws.QNAME
       , PARAM_MODE VARCHAR2(30)
  );
  TYPE WS_PARAMETER_TBL_TYPE IS TABLE OF WS_PARAMETER_REC_TYPE;


-- ----------------------------------------------------------
-- 构建参数列表存储过程add_param
-- ----------------------------------------------------------
-- 重载过程1：构建字符串类型参数
--
PROCEDURE add_param(
           p_param_list IN OUT NOCOPY WS_PARAMETER_TBL_TYPE
         , p_param_name IN VARCHAR2
         , p_value IN VARCHAR2
         , p_mode IN utl_dbws.QNAME
);
-- 重载过程2：构建数字类型参数
PROCEDURE add_param(
           p_param_list IN OUT NOCOPY WS_PARAMETER_TBL_TYPE
         , p_param_name IN VARCHAR2
         , p_value IN NUMBER
         , p_mode IN utl_dbws.QNAME
);

--
-- 尝试将返回的字符串转换成xml对象（XMLType类型）
-- 如果标准方法转换失败，并且失败的原因是没有根节点
-- 程序将在外围添加额外的根节点ROOT，其他情况继续向外
-- 抛出错误
-- 要处理的异常如下：
-- ORA-31011: XML parsing failed
-- LPX-00245: extra data after end of document
-- 参数说明：
-- p_xml_frgmt      带解析的xml字符串
-- x_ret_extra_node 如果解析失败，该参数将保存新增节点
--                  的名称
--
FUNCTION to_XML(
           p_xml_frgmt IN VARCHAR2
         , x_ret_extra_node OUT NOCOPY VARCHAR2)
RETURN XMLTYPE;

--
-- 为不合法的xml添加根节点
--
FUNCTION wrap_xml_with(
           p_root_element  IN VARCHAR2
         , p_xml_frgmt     IN VARCHAR2
) RETURN VARCHAR2;

--
-- 初始化utl_dbws调用的web服务的环境
-- 该函数必须在调用任何operations之前执行
--
FUNCTION init_service(
           p_namespace   IN VARCHAR2
         , p_serive_name IN VARCHAR2
         , p_port_name   IN VARCHAR2
         , p_wsdl_uri    IN VARCHAR2
) RETURN BOOLEAN;

--
-- 调用服务方法
--
FUNCTION invoke_operation(
           p_operation_name IN VARCHAR2
         , p_request_params IN WS_PARAMETER_TBL_TYPE
) RETURN AnyData;
-- 重载函数，直接处理XML参数
FUNCTION invoke_operation(
           p_operation_name IN VARCHAR2
         , p_request_params IN XMLTYPE
) RETURN XMLTYPE;

--
-- 释放服务资源
--
PROCEDURE release_service;

END CUX_DBWS_HELPER;
/
