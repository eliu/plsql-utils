-- 查找供应商关联的银行账户信息
SELECT cb.bank_name,
       cbb.bank_branch_name,
       ieba.bank_account_num,
       ieba.masked_bank_account_num,
       ieba.bank_account_name
  FROM ap_suppliers s,
       iby_account_owners iao,
       iby_ext_bank_accounts ieba,
       ce_banks_v            cb,
       ce_bank_branches_v    cbb
 WHERE cb.bank_party_id = ieba.bank_id
   and cbb.branch_party_id = ieba.branch_id
   and ieba.ext_bank_account_id = iao.ext_bank_account_id
   and iao.account_owner_party_id = s.party_id
   and s.vendor_name = 'Dell Computers'; 