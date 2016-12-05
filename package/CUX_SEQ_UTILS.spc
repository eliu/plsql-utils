create or replace PACKAGE cux_seq_utils AS
  PROCEDURE reset_seq(p_seq_name    IN VARCHAR2,
                      p_last_number IN NUMBER DEFAULT NULL);
END cux_seq_utils;