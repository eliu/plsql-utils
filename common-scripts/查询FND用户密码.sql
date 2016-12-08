-- Create package
CREATE OR REPLACE PACKAGE GET_PWD AS 
  FUNCTION DECRYPT(KEY IN VARCHAR2, VALUE IN VARCHAR2) RETURN VARCHAR2; 
END GET_PWD; 
/
CREATE OR REPLACE PACKAGE BODY GET_PWD AS 
  FUNCTION DECRYPT(KEY IN VARCHAR2, VALUE IN VARCHAR2) 
    RETURN VARCHAR2 AS LANGUAGE JAVA NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String'; 
END GET_PWD;
/
-- Get password
SELECT USR.USER_NAME,
       GET_PWD.DECRYPT((SELECT (SELECT GET_PWD.DECRYPT(FND_WEB_SEC.GET_GUEST_USERNAME_PWD,
                                                      USERTABLE.ENCRYPTED_FOUNDATION_PASSWORD)
                                 FROM DUAL) AS APPS_PASSWORD
                         FROM APPS.FND_USER USERTABLE
                        WHERE USERTABLE.USER_NAME =
                              (SELECT SUBSTR(FND_WEB_SEC.GET_GUEST_USERNAME_PWD,
                                             1,
                                             INSTR(FND_WEB_SEC.GET_GUEST_USERNAME_PWD,
                                                   '/') - 1)
                                 FROM DUAL)),
                       USR.ENCRYPTED_USER_PASSWORD) PASSWORD
  FROM APPS.FND_USER USR
 WHERE USR.USER_NAME = UPPER('&USER_NAME')
;
DROP PACKAGE GET_PWD;
