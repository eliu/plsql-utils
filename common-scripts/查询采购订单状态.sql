DECLARE
  l_po_header_id        NUMBER := 97889;
  l_po_status_rec       PO_STATUS_REC_TYPE;
  l_return_status       VARCHAR2(1);
  l_autorization_status VARCHAR2(30);
  l_po_release_id       NUMBER;
BEGIN
  mo_global.set_policy_context('S', 88);
  po_document_checks_grp.po_status_check(p_api_version   => 1.0,
                                         p_header_id     => l_po_header_id,
                                         p_mode          => 'GET_STATUS',
                                         x_po_status_rec => l_po_status_rec,
                                         x_return_status => l_return_status);
  dbms_output.put_line(l_return_status);
  l_autorization_status := l_po_status_rec.approval_flag(1);
  dbms_output.put_line('status = ' || l_autorization_status);
END;
