--系统中所有的BU
Select Buname.Organization_Id, Buname.Name
  From Hr_Organization_Information Buinfo, Hr_All_Organization_Units Buname
 Where Buinfo.Org_Information_Context = 'CLASS'
   And Buinfo.Org_Information1 = 'HR_BG'
   And Buinfo.Organization_Id = Buname.Organization_Id;

--系统中所有的法人实体, 以其对应的主账套
Select Le.Legal_Entity_Id,
       Le.Name,
       Le.Effective_From,
       Le.Effective_To,
       (Select Max(l.Ledger_Id)
          From Gl_Ledgers l, Gl_Ledger_Config_Details c
         Where l.Configuration_Id = c.Configuration_Id
           And c.Object_Type_Code = 'LEGAL_ENTITY'
           And c.Object_Id = Le.Legal_Entity_Id
           And l.Ledger_Category_Code = 'PRIMARY') Primary_Ledger_Id
  From Xle.Xle_Entity_Profiles Le;

--系统中所有OU 以及对应的 Le/Ledger
Select Ouname.Organization_Id,
       Ouname.Name,
       Ououinfo.Org_Information2 Belongto_Le_Orgid,
       Ououinfo.Org_Information3 Belongto_Ledgerid
  From Hr_Organization_Information Ouinfo, Hr_Organization_Information Ououinfo, Hr_All_Organization_Units Ouname
 Where Ouinfo.Org_Information_Context = 'CLASS'
   And Ouinfo.Org_Information1 = 'OPERATING_UNIT'
   And Ouinfo.Organization_Id = Ououinfo.Organization_Id
   And Ououinfo.Org_Information_Context = 'Operating Unit Information'
   And Ououinfo.Organization_Id = Ouname.Organization_Id;

--系统中所有库存组织 以其对应的 OU
Select Invname.Organization_Id,
       Invname.Name,
       Invaccountinfo.Org_Information3 Belongto_Ou_Orgid,
       Invpara.Organization_Code
  From Hr_Organization_Information Invinfo,
       Hr_Organization_Information Invaccountinfo,
       Hr_All_Organization_Units   Invname,
       Mtl_Parameters_View         Invpara
 Where Invinfo.Org_Information_Context = 'CLASS'
   And Invinfo.Org_Information1 = 'INV'
   And Invinfo.Org_Information2 = 'Y'
   And Invinfo.Organization_Id = Invaccountinfo.Organization_Id
   And Invaccountinfo.Org_Information_Context = 'Accounting Information'
   And Invinfo.Organization_Id = Invname.Organization_Id
   And Invname.Organization_Id = Invpara.Organization_Id;

Select * From Org_Organization_Definitions;