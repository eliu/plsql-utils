DECLARE
  l_xml_data   XMLTYPE;
  l_dom_object dbms_xmldom.DOMElement;
  l_job_list   dbms_xmldom.DOMNodeList;
  l_job_node   dbms_xmldom.DOMNode;

  l_root_list  dbms_xmldom.DOMNodeList;
  l_root_node  dbms_xmldom.DOMNode;
BEGIN
  l_xml_data   := XMLTYPE('<root><career>Hello,<job>Consultant</job>Eric</career></root>');
  -- 得到DOM对象
  l_dom_object := cux_xmldom_helper.Get_Dom_Element(l_xml_data);
  -- 利用DOM API get_Elements_By_Tag_Name获取元素
  l_job_list   := dbms_xmldom.getElementsByTagName(l_dom_object, 'job');
  -- 得到第一个子元素
  l_job_node := dbms_xmldom.item(l_job_list, 0);
  -- 输出job节点内的文本值：Consultant
  dbms_output.put_line(cux_xmldom_helper.inner_text(l_job_node));

  l_root_list := dbms_xmldom.getElementsByTagName(l_dom_object, 'career');
  l_root_node := dbms_xmldom.item(l_root_list, 0);
  dbms_output.put_line(cux_xmldom_helper.inner_text(l_root_node));
END;
