CREATE OR REPLACE PACKAGE BODY CUX_XMLDOM_HELPER
AS

FUNCTION get_dom_element(
           p_xml_source IN XMLTYPE
) RETURN dbms_xmldom.DOMElement IS

  v_dom_doc dbms_xmldom.DOMDocument;

BEGIN
  -- 根据给定的XML创建DOM document
  v_dom_doc  := dbms_xmldom.newDOMDocument(p_xml_source);
  -- 得到并返回转换后的DocumentElement
  RETURN (dbms_xmldom.getDocumentElement(v_dom_doc));
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    RETURN NULL;
END;

FUNCTION inner_text(
           p_node       IN dbms_xmldom.DOMNode
         , p_trim_blank IN VARCHAR2 DEFAULT fnd_api.G_FALSE
) RETURN VARCHAR2 IS

  v_length       NUMBER;
  v_node         dbms_xmldom.DOMNode;
  v_childnodes   dbms_xmldom.DOMNodeList;

  v_node_text    VARCHAR2(2000);
  x_rs_node_text VARCHAR2(32767);
BEGIN
  -- 若当前的节点类型为文本节点，则直接返回该节点的文本内容
  IF dbms_xmldom.getNodeType(p_node) = dbms_xmldom.TEXT_NODE THEN
    RETURN (dbms_xmldom.getNodeValue(p_node));
  END IF;

  -- 若为其他类型元素
  -- 获取类型那么
  --，那么
  v_childnodes := dbms_xmldom.getChildNodes(p_node);
  -- get number of child elements
  v_length     := dbms_xmldom.getLength(v_childnodes);

  -- iterate each node, append text if its a text node
  FOR idx IN 0..v_length - 1 LOOP
    v_node := dbms_xmldom.item(v_childnodes, idx);

    IF dbms_xmldom.getNodeType(v_node) = dbms_xmldom.TEXT_NODE THEN
      v_node_text := dbms_xmldom.getNodeValue(v_node);

      IF fnd_api.To_Boolean(p_trim_blank) THEN
        v_node_text := trim(replace(v_node_text, chr(10), ''));
      END IF;

      x_rs_node_text := nvl(x_rs_node_text, '') || v_node_text;
    END IF;
  END LOOP;

  RETURN (x_rs_node_text);
END inner_text;

END CUX_XMLDOM_HELPER;
/
