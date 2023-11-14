DECLARE
    l_onhand              NUMBER;
    l_qoh                 NUMBER;
    l_rqoh                NUMBER;
    l_qr                  NUMBER;
    l_qs                  NUMBER;
    l_atr                 NUMBER;
    l_att                 NUMBER;
    
    l_is_lot_control_flag BOOLEAN;
    l_is_lot_control      VARCHAR2(1);
  
    x_return_status       VARCHAR2(30);
    x_msg_count           NUMBER;
    x_msg_data            VARCHAR2(2000);
    
    l_item_code           VARCHAR2(80) := '1001001054';
    l_organization_code   VARCHAR2(30) := 'A24';
    l_item_id             NUMBER;
    l_organization_id     NUMBER;
BEGIN
  SELECT inventory_item_id, msi.organization_id
    INTO l_item_id, l_organization_id
    FROM mtl_system_items_b msi,
         mtl_parameters     mp
   WHERE mp.organization_id = msi.organization_id
     AND msi.segment1 = l_item_code
     AND mp.organization_code = l_organization_code;
  inv_quantity_tree_pub.query_quantities(p_api_version_number  => 1.0,
                                           p_init_msg_lst        => NULL,
                                           x_return_status       => x_return_status,
                                           x_msg_count           => x_msg_count,
                                           x_msg_data            => x_msg_data,
                                           p_organization_id     => l_organization_id, --仓库ID
                                           p_inventory_item_id   => l_item_id, --物料ID
                                           p_tree_mode           => inv_quantity_tree_pub.g_transaction_mode,
                                           p_is_revision_control => FALSE,
                                           p_is_lot_control      => FALSE, --是否启用批次控制 且限制批次
                                           p_is_serial_control   => FALSE,
                                           p_revision            => NULL,
                                           p_lot_number          => NULL, --rec_loc.lot_number,
                                           p_lot_expiration_date => NULL, --rec_loc.expiration_date,
                                           p_subinventory_code   => NULL, --子库code
                                           p_locator_id          => NULL, --rec_loc.locator_id, 4071
                                           p_cost_group_id       => NULL,
                                           --p_onhand_source       => inv_quantity_tree_pvt.g_all_subs,
                                           x_qoh                 => l_qoh, --现有量
                                           x_rqoh                => l_rqoh,
                                           x_qr                  => l_qr,
                                           x_qs                  => l_qs,
                                           x_att                 => l_att,
                                           x_atr                 => l_atr);
  -- Output all quantities
  dbms_output.put_line('Organization                is ' || l_organization_code);
  dbms_output.put_line('Item                        is ' || l_item_code);
  dbms_output.put_line('-------------------------------------');
  dbms_output.put_line('quantity on hand            is ' || l_qoh);
  dbms_output.put_line('reservable quantity on hand is ' || l_rqoh);
  dbms_output.put_line('quantity reserved           is ' || l_qr);
  dbms_output.put_line('quantity suggested          is ' || l_qs);
  dbms_output.put_line('available to transact       is ' || l_att);
  dbms_output.put_line('available to reserve        is ' || l_atr);
END;
/
