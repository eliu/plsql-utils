CREATE OR REPLACE PACKAGE CUX_XMLDOM_HELPER
/* $Header: CUX_XMLDOM_HELPER.pck 1.0 2010/11/24 eric.liu noship $ */
/*==================================================
   Copyright (C) Hand Enterprise Solutions Co.,Ltd.
                All Rights Reserved
 ==================================================*/
/*==================================================
   Program Name:
      CUX_XMLDOM_HELPER
   Description:
      基于dbms_xmldom包基础上并简化对DOM文档处理的工具包
      该程序包仅针对于利用DOM方式处理XML文档提供便捷方法
      以简化开发
   History:

      1.0  2010-11-24  eric.liu  Creation
 ==================================================*/
AS

--
-- 根据XMLType类型变量得到对应可进行DOM操作的DOMDocument对象
-- 所有对XML的DOM操作均基于该对象
--
FUNCTION get_dom_element(
           p_xml_source IN XMLTYPE
) RETURN dbms_xmldom.DOMElement;

--
-- 获取一个节点下的文本
-- 参数说明：
-- p_node 要获取文本的DOM节点
-- p_trim_blank 是否将文本两端的空白字符去除
FUNCTION inner_text(
           p_node       IN dbms_xmldom.DOMNode
         , p_trim_blank IN VARCHAR2 DEFAULT fnd_api.G_FALSE
) RETURN VARCHAR2;

END CUX_XMLDOM_HELPER;
/
