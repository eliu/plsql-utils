CREATE OR REPLACE PACKAGE BODY cux_seq_utils AS
  PROCEDURE reset_seq(p_seq_name    IN VARCHAR2,
                      p_last_number IN NUMBER DEFAULT NULL) IS
    l_val NUMBER;
  BEGIN
    EXECUTE IMMEDIATE 'select ' || p_seq_name || '.nextval from dual'
      INTO l_val;

    EXECUTE IMMEDIATE 'alter sequence ' || p_seq_name || ' increment by -' ||
                      l_val || ' minvalue 0';

    EXECUTE IMMEDIATE 'select ' || p_seq_name || '.nextval from dual'
      INTO l_val;

    EXECUTE IMMEDIATE 'alter sequence ' || p_seq_name ||
                      ' increment by 1 minvalue 0';

    IF (p_last_number > 1) THEN
      EXECUTE IMMEDIATE 'alter sequence ' || p_seq_name || ' increment by ' ||
                        (p_last_number - 1);
      EXECUTE IMMEDIATE 'select ' || p_seq_name || '.nextval from dual'
        INTO l_val;
      EXECUTE IMMEDIATE 'alter sequence ' || p_seq_name ||
                        ' increment by 1';
    END IF;
  END reset_seq;
END cux_seq_utils;
