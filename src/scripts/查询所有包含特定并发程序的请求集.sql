SELECT FCP.CONCURRENT_PROGRAM_NAME, 
       FCP.USER_CONCURRENT_PROGRAM_NAME,
       FRS.REQUEST_SET_NAME,
       FRS.USER_REQUEST_SET_NAME
  FROM FND_REQUEST_SET_PROGRAMS RSR,
       FND_REQUEST_SETS_VL      FRS,
       FND_CONCURRENT_PROGRAMS_VL  FCP
 WHERE FRS.APPLICATION_ID = RSR.SET_APPLICATION_ID
   AND FRS.REQUEST_SET_ID = RSR.REQUEST_SET_ID
   AND RSR.PROGRAM_APPLICATION_ID = FCP.APPLICATION_ID
   AND RSR.CONCURRENT_PROGRAM_ID = FCP.CONCURRENT_PROGRAM_ID
   AND FCP.CONCURRENT_PROGRAM_NAME = '&PROGRAM_NAME';
