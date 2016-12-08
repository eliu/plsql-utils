PACKAGE BODY app_record2 IS
  g_default_exclude_field constant varchar2(30) := '_PLACE_HOLDER_';

  PROCEDURE set_alterable(value           IN NUMBER,
                          excluded_field1 IN VARCHAR2 DEFAULT NULL,
                          excluded_field2 IN VARCHAR2 DEFAULT NULL,
                          excluded_field3 IN VARCHAR2 DEFAULT NULL,
                          excluded_field4 IN VARCHAR2 DEFAULT NULL,
                          excluded_field5 IN VARCHAR2 DEFAULT NULL)
  IS
    l_block_name      VARCHAR2(240);
    l_block_id        BLOCK;
    l_item_name       VARCHAR2(240);
    l_item_id         ITEM;
    l_item_type       VARCHAR2(240);
    l_item_canvas     VARCHAR2(240);
  BEGIN
    l_block_name := name_in('SYSTEM.CURSOR_BLOCK');             -- 获取光标当前所在数据块
    l_block_id   := find_block(l_block_name);                   -- 得到数据块ID
    l_item_name  := get_block_property(l_block_id, FIRST_ITEM); -- 得到数据块中的第一个ITEM

    loop
      l_item_id     := find_item(l_block_name || '.' || l_item_name); -- 得到项ID
      l_item_type   := get_item_property(l_item_id, ITEM_TYPE);       -- 得到项类型
      l_item_canvas := get_item_property(l_item_id, ITEM_CANVAS);     -- 得到项所在的画布名称

      if ((l_item_type IN ('TEXT ITEM', 'LIST', 'DISPLAY ITEM', 'CHECKBOX')) AND
          (l_item_canvas IS NOT NULL) AND
          (l_item_name NOT IN ('CURRENT_RECORD_INDICATOR',
                                'DRILLDOWN_RECORD_INDICATOR',
                                'SWITCHER',
                                'FOLDER_SWITCHER',
                                -- Other excluded items
                                NVL(excluded_field1, g_default_exclude_field),
                                NVL(excluded_field2, g_default_exclude_field),
                                NVL(excluded_field3, g_default_exclude_field),
                                NVL(excluded_field4, g_default_exclude_field),
                                NVL(excluded_field5, g_default_exclude_field))))
      then
          app_item_property.set_property(l_item_id, ALTERABLE, value);
      end if;

      l_item_name := get_item_property(l_item_id, NEXTITEM);
      exit when l_item_name is null or l_item_name = 'APPCORE_STOP';
    end loop;
  END set_alterable;
END;
/
