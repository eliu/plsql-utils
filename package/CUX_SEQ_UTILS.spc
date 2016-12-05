CREATE OR REPLACE PACKAGE cux_seq_utils AS
  /*==========================================================================+
  |       Name  : reset_seq
  | Description : Reset the last number of specified sequence.
  |
  |   Arguments :
  |              p_seq_name     Name of the sequence
  |              p_last_number  Last number you want to reset (Optional),
  |                             The program will reset the last number of seq
  |                             as 1 by default if this param is not provided.
  |       Notes :
  |
  |    History  :
  |             DD-MON-YY    Developer          Change
  |             -----------  --------------     ------------
  |             05-DEC-16    eliu               Created
  +==========================================================================*/
  PROCEDURE reset_seq(p_seq_name    IN VARCHAR2,
                      p_last_number IN NUMBER DEFAULT NULL);
END cux_seq_utils;
