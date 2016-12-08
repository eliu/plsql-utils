PACKAGE app_record2 IS
  PROCEDURE set_alterable(value           IN NUMBER,
                          excluded_field1 IN VARCHAR2 DEFAULT NULL,
                          excluded_field2 IN VARCHAR2 DEFAULT NULL,
                          excluded_field3 IN VARCHAR2 DEFAULT NULL,
                          excluded_field4 IN VARCHAR2 DEFAULT NULL,
                          excluded_field5 IN VARCHAR2 DEFAULT NULL);
END;
/
