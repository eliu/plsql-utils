SELECT APP.APPLICATION_NAME,
       FCP.CONCURRENT_PROGRAM_NAME, 
       FCP.USER_CONCURRENT_PROGRAM_NAME,
       FCP.MULTI_ORG_CATEGORY,
       EXE.EXECUTABLE_NAME,
       EMC.MEANING EXECUTION_METHOD,
       EXE.EXECUTION_FILE_NAME,
       COL.COLUMN_SEQ_NUM,
       COL.END_USER_COLUMN_NAME,
       COL.SRW_PARAM TOKEN,
       COL.FLEX_VALUE_SET_ID,
       FFVS.FLEX_VALUE_SET_NAME,
       COL.ENABLED_FLAG,
       COL.REQUIRED_FLAG,
       COL.DISPLAY_FLAG,
       COL.DISPLAY_SIZE,
       COL.DEFAULT_TYPE,
       COL.DEFAULT_VALUE,
       COL.FORM_LEFT_PROMPT
  FROM FND_DESCR_FLEX_COL_USAGE_VL COL,
       FND_CONCURRENT_PROGRAMS_VL  FCP,
       FND_APPLICATION_VL          APP,
       FND_LOOKUP_VALUES_VL        EMC, -- Execution Method Code
       FND_EXECUTABLES_VL          EXE,
       FND_FLEX_VALUE_SETS         FFVS
 WHERE EMC.LOOKUP_TYPE = 'CP_EXECUTION_METHOD_CODE'
   AND EMC.LOOKUP_CODE = EXE.EXECUTION_METHOD_CODE
   AND EXE.APPLICATION_ID = FCP.APPLICATION_ID
   AND EXE.EXECUTABLE_ID = FCP.EXECUTABLE_ID
   AND APP.APPLICATION_ID = FCP.APPLICATION_ID
   AND FFVS.FLEX_VALUE_SET_ID = COL.FLEX_VALUE_SET_ID
   AND COL.APPLICATION_ID = FCP.APPLICATION_ID
   AND COL.DESCRIPTIVE_FLEXFIELD_NAME = '$SRS$.' || FCP.CONCURRENT_PROGRAM_NAME 
   AND FCP.CONCURRENT_PROGRAM_NAME = '&PROGRAM'
   /*AND EXE.EXECUTABLE_NAME = '&EXECUTABLE'*/
 ORDER BY FCP.CONCURRENT_PROGRAM_NAME, COLUMN_SEQ_NUM
;

