CREATE OR REPLACE PACKAGE UTL_SMTP_HELPER
--==========================================================
--Package Name : UTL_SMTP_HELPER
--Discription  : This is a helper package spec. for sending
--               email using smtp and ecapsulate the UTL_SMTP
--               APIs.
--Language     : PL/SQL
--Modify
--  1.0.0
--    Argument : New Development
--    Date     : 10-JUN-2011 11:40
--    Author   : Eric Liu
--    Note     :
--  1.0.1
--    Argument : Update
--    Date     : 14-JUN-2011 11:40
--    Author   : Eric Liu
--    Note     : Refactor code
--  1.0.2
--    Argument : Update
--    Date     : 09-MAY-2012 10:27
--    Author   : Eric Liu
--    Note     : The API now supports multiple recipients 
--==========================================================
AS
    --------------------------------------------------------
    -- PUBLIC: Global variable decalrations
    --------------------------------------------------------
    --
    -- SMTP Connection handle
    --
    SUBTYPE SMTP_CONNECTION IS BINARY_INTEGER;
    --
    -- Content types
    --
    g_HTML_CONTENT  CONSTANT VARCHAR2(10) := 'text/html';
    g_TEXT_CONTENT  CONSTANT VARCHAR2(10) := 'text/plain';
    
    --
    -- Store multiple recipients
    --
    type recipient_type is record(
      recipient     varchar2(120),
      email_address varchar2(200)
    );
    type recipient_list is table of recipient_type index by binary_integer;
    
    -- =======================================
    -- FUNCTION Create_Smtp_Connection
    -- ** Initialize smtp connection data and
    --    open it.
    --
    -- ARGUMENTS
    --   p_smtp_hostname   smtp hostname
    --   p_smtp_port_num   smtp port number
    --   x_smtp_conn       smtp connect handle
    -- =======================================
    FUNCTION Create_Smtp_Connection(p_smtp_hostname IN VARCHAR2,
                                    p_smtp_port_num IN NUMBER DEFAULT 25,
                                    x_smtp_conn     IN OUT NOCOPY SMTP_CONNECTION)
      RETURN BOOLEAN;


    -- =======================================
    -- FUNCTION Set_Header
    -- ** generate a mail header information
    --
    -- ARGUMENTS
    --   p_smtp_conn      smtp handle
    --   p_subject        subject
    --   p_from           sender addr.
    --   p_sender         sender
    --   p_recipient_list a list of recipient information
    --   p_cc1            cc1
    --   p_cc2            cc2
    --   p_charset        mail charset
    --   p_db_charset     database character set
    -- =======================================
    PROCEDURE Set_Header(p_smtp_conn      IN SMTP_CONNECTION,
                         p_subject        IN VARCHAR2,
                         p_from           IN VARCHAR2,
                         p_sender         IN VARCHAR2 DEFAULT NULL,
                         p_recipient_list in recipient_list,
                         p_cc1            IN VARCHAR2 DEFAULT NULL,
                         p_cc2            IN VARCHAR2 DEFAULT NULL,
                         p_charset        IN VARCHAR2 DEFAULT NULL,
                         p_db_charset     IN VARCHAR2 DEFAULT NULL);

    -- =======================================
    -- FUNCTION Add_Body
    -- ** generate the mail body
    --
    -- ARGUMENTS
    --   p_smtp_conn       smtp handle
    --   p_content_type    content type
    --   p_body            text/html body
    -- =======================================
    PROCEDURE Add_Body(p_smtp_conn    IN SMTP_CONNECTION,
                       p_content_type IN VARCHAR2 DEFAULT g_TEXT_CONTENT,
                       p_body         IN VARCHAR2);

    -- =======================================
    -- FUNCTION Add_Attachment
    -- ** generate a mail attachment
    --
    -- ARGUMENTS
    --   p_smtp_conn    smtp handle
    --   p_file_path    file path alias that
    --                  should be defined in
    --                  all_directories table.
    --   p_file_name    file name
    -- =======================================
    PROCEDURE Add_Attachment(p_smtp_conn IN SMTP_CONNECTION,
                             p_file_path IN VARCHAR2,
                             p_file_name IN VARCHAR2);

    -- =======================================
    -- FUNCTION Add_Attachment
    -- ** generate at most 5 attachments, the
    --    source file of which must be in the
    --    same file path.
    --
    -- ARGUMENTS
    --   p_smtp_conn    smtp handle
    --   p_file_path    file path alias that
    --                  should be defined in
    --                  all_directories table.
    --   p_file_name1   file1
    --   p_file_name2   file2
    --   p_file_name3   file3
    --   p_file_name4   file4
    --   p_file_name5   file5
    -- =======================================
    PROCEDURE Add_Attachments(p_smtp_conn  IN SMTP_CONNECTION,
                              p_file_path  IN VARCHAR2,
                              p_file_name1 IN VARCHAR2,
                              p_file_name2 IN VARCHAR2 DEFAULT NULL,
                              p_file_name3 IN VARCHAR2 DEFAULT NULL,
                              p_file_name4 IN VARCHAR2 DEFAULT NULL,
                              p_file_name5 IN VARCHAR2 DEFAULT NULL);

    -- =======================================
    -- FUNCTION Send
    -- ** write data to utl_smtp and send email
    --
    -- ARGUMENTS
    --   p_smtp_conn   smtp handle
    -- =======================================
    PROCEDURE Send(p_smtp_conn IN SMTP_CONNECTION);

    -- =======================================
    -- FUNCTION Disconnect
    -- ** Release one smtp resource back to
    --    the system.
    --
    -- ARGUMENTS
    --   p_smtp_conn   smtp handle
    -- =======================================
    PROCEDURE Disconnect(p_smtp_conn IN SMTP_CONNECTION);

    -- =======================================
    -- FUNCTION html_body
    -- ** Release all smtp resources that has
    --    registered in this package.
    --
    -- ARGUMENTS
    -- =======================================
    PROCEDURE Disconnect_All;
END UTL_SMTP_HELPER;
/
EXIT;
