/*==================================================
    Procedure Name:
        get_txn_source.sql
    Description:
        This procedure is used to calculate transaction
        source name of one specified material transaction.
    Arguments
        p_transaction_id  IN  *material transaction id
        x_txn_source      OUT *transaction source name
    History:
        1.00  2012-03-01  eliu  Creation
  ==================================================*/
  procedure get_txn_source(
              p_transaction_id in number
            , x_txn_source     out nocopy varchar2
            )
  is
    PO                   CONSTANT NUMBER  := 1;
    Sales_Order          CONSTANT NUMBER  := 2;
    Account              CONSTANT NUMBER  := 3;
    Move_Order           CONSTANT NUMBER  := 4;
    WIP_Job_or_Schedule  CONSTANT NUMBER  := 5;
    Account_Alias        CONSTANT NUMBER  := 6;
    Requisition          CONSTANT NUMBER  := 7;
    Internal_Order       CONSTANT NUMBER  := 8;
    Cycle_count          CONSTANT NUMBER  := 9;
    Physical_inventory   CONSTANT NUMBER  := 10;
    Cost_update          CONSTANT NUMBER  := 11;
    RMA                  CONSTANT NUMBER  := 12;
    Inventory            CONSTANT NUMBER  := 13;
    --Layer_cost_update    CONSTANT NUMBER  := 15;
    PrjContracts         CONSTANT NUMBER  := 16;

    v_process_phase      varchar2(30);
    n_organization_id    number;
    n_txn_source_type_id number;
    n_txn_source_id      number;
    v_txn_source_name    MTL_MATERIAL_TRANSACTIONS.TRANSACTION_SOURCE_NAME%TYPE;
  begin
    v_process_phase := 'Fetch txn infomation';
    -- get transaction information
    SELECT MMT.ORGANIZATION_ID,
           MMT.TRANSACTION_SOURCE_TYPE_ID,
           MMT.TRANSACTION_SOURCE_ID,
           MMT.TRANSACTION_SOURCE_NAME
      INTO n_organization_id,
           n_txn_source_type_id,
           n_txn_source_id,
           v_txn_source_name
      FROM MTL_MATERIAL_TRANSACTIONS MMT
     WHERE MMT.TRANSACTION_ID = p_transaction_id
    ;

    if n_txn_source_type_id = Cost_update then
      v_process_phase := 'Cost Update';
      SELECT DESCRIPTION INTO x_txn_source
        FROM CST_COST_UPDATES
       WHERE COST_UPDATE_ID = n_txn_source_id
      ;
    elsif n_txn_source_type_id = Cycle_count then
      v_process_phase := 'Cycle Count';
      SELECT CYCLE_COUNT_HEADER_NAME
        INTO x_txn_source
        FROM MTL_CYCLE_COUNT_HEADERS
       WHERE CYCLE_COUNT_HEADER_ID = n_txn_source_id
         AND organization_id = n_organization_id
      ;
    elsif (n_txn_source_type_id = Inventory or n_txn_source_type_id >= 100) then
      v_process_phase := 'Inventory';
      x_txn_source := v_txn_source_name;
    elsif  n_txn_source_type_id = Physical_inventory then
      v_process_phase := 'Physical Inventory';
      SELECT PHYSICAL_INVENTORY_NAME
        INTO x_txn_source
        FROM MTL_PHYSICAL_INVENTORIES
       WHERE PHYSICAL_INVENTORY_ID = n_txn_source_id
         AND organization_id = n_organization_id
      ;
    elsif n_txn_source_type_id = PO then
      v_process_phase := 'PO';
      select nvl(CLM_DOCUMENT_NUMBER, POH.SEGMENT1)
        INTO x_txn_source
        from po_headers_all poh
       where poh.po_header_id = n_txn_source_id
      ;
    elsif n_txn_source_type_id = PrjContracts then
      v_process_phase := 'PrjContracts';
      SELECT contract_number
        INTO x_txn_source
        FROM okc_k_headers_b
       WHERE id = n_txn_source_id
      ;
    elsif n_txn_source_type_id = Requisition then
      v_process_phase := 'Requisition';
      SELECT SEGMENT1
        INTO x_txn_source
        FROM PO_REQUISITION_HEADERS_ALL
       WHERE REQUISITION_HEADER_ID = n_txn_source_id
      ;
    elsif n_txn_source_type_id = WIP_Job_or_Schedule then
      v_process_phase := 'WIP Job or Schedule';
      SELECT WIP_ENTITY_NAME
        INTO x_txn_source
        FROM WIP_ENTITIES
       WHERE WIP_ENTITY_ID = n_txn_source_id
         AND organization_id = n_organization_id
      ;
    elsif n_txn_source_type_id = Move_Order then
      v_process_phase := 'Move Order';
      SELECT REQUEST_NUMBER
        INTO x_txn_source
        FROM MTL_TXN_REQUEST_HEADERS
       WHERE HEADER_ID = n_txn_source_id
         AND organization_id = n_organization_id
      ;
    elsif ( (n_txn_source_type_id = Sales_Order) OR
            (n_txn_source_type_id = Internal_Order) OR
            (n_txn_source_type_id = RMA) ) then
      v_process_phase := 'Sales Order';
      select concatenated_segments
        into x_txn_source
        from MTL_SALES_ORDERS_KFV
       where SALES_ORDER_ID = n_txn_source_id
      ;
    elsif n_txn_source_type_id = Account_Alias then
      v_process_phase := 'Account Alias';
      select concatenated_segments
        into x_txn_source
        from MTL_GENERIC_DISPOSITIONS_KFV
       where disposition_id = n_txn_source_id
      ;
    elsif n_txn_source_type_id = Account then
      v_process_phase := 'Account';
      select concatenated_segments
        into x_txn_source
        from GL_CODE_COMBINATIONS_KFV
       where CODE_COMBINATION_ID = n_txn_source_id
      ;
    else
      -- We do not need display txn source for other types.
      -- including Layer_cost_update
      v_process_phase := 'Others';
      x_txn_source := null;
    end if;

  EXCEPTION
    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
      if g_debug_mode = 'Y' then
        dbms_output.put_line('GET_TXN_SOURCE: ' || SQLERRM);
        dbms_output.put_line('Process phase : ' || v_process_phase);
      end if;
      x_txn_source := null;
  end;
