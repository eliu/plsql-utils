SELECT LPAD(' ', (LEVEL - 1) * 2, ' ') || NVL(SUB.USER_MENU_NAME, FME.PROMPT) MENU_OR_PROMPT,
       PRT.USER_MENU_NAME PARENT_MENU,
       (SELECT listagg(resp.responsibility_name, ',')
               WITHIN GROUP (ORDER BY resp.responsibility_name)
          FROM FND_RESPONSIBILITY_VL RESP
         WHERE RESP.MENU_ID = PRT.MENU_ID) RESPONSIBILITIES
  FROM FND_MENU_ENTRIES_VL   FME,
       FND_FORM_FUNCTIONS_VL FFF,
       FND_MENUS_VL          PRT,
       FND_MENUS_VL          SUB
 WHERE FME.FUNCTION_ID = FFF.FUNCTION_ID (+)
   AND FME.MENU_ID = PRT.MENU_ID
   AND FME.SUB_MENU_ID = SUB.MENU_ID (+)
 START WITH 
       FFF.FUNCTION_NAME = '&FUNCTION_NAME'
 CONNECT BY 
       PRIOR FME.MENU_ID = FME.SUB_MENU_ID
