DECLARE
        smtp_conn utl_smtp_helper.SMTP_CONNECTION;
        successed BOOLEAN;
    BEGIN
        -- create one smtp connection
        successed :=
        utl_smtp_helper.Create_Smtp_Connection (
            p_smtp_hostname => '<smtp host>', -- change as needed
            x_smtp_conn => smtp_conn
        );
        
        IF successed THEN
        -- Set mail header
        utl_smtp_helper.Set_Header (
            p_smtp_conn        => smtp_conn,
            p_from            => '<foo@hostname.com>', -- change as needed
            p_sender        => 'sender',
            p_to            => '<bar@hostname.com>', -- change as needed
            p_receiver        => 'receiver',
            --p_cc1            => 'cc1@hostname.com',
            --p_cc2            => 'cc2@hostname.com',
            p_subject        => 'Subject',
            p_charset        => 'gb2312'
            --p_db_charset    => 'UTF8'
        );

        -- Append mail body
        utl_smtp_helper.Add_Body (
            p_smtp_conn        => smtp_conn,
            p_content_type  => utl_smtp_helper.g_HTML_CONTENT,
            p_body            => '<h1>Test</h1>'
        );
        -- or adding plain text body
        /*
        utl_smtp_helper.Add_Body (
            p_smtp_conn        => smtp_conn,
            p_content_type  => utl_smtp_helpr.TEXT_CONTENT,
            p_body            => 'HTML Body'
        );
        */

        -- add attachments
        utl_smtp_helper.Add_Attachment(
            p_smtp_conn        => smtp_conn,
            p_file_path        => 'ZZ_TMP_FILE_PATH',
            p_file_name        => 'test_data.txt'
        );
        -- or add multi attachments in the same base path
        /*
        utl_smtp_helper.Add_Attachments(
            p_smtp_conn        => smtp_conn,
            p_file_path        => '/usr/tmp',
            p_file_name1    => 'filename1.ext',
            p_file_name2    => 'filename2.ext',
            p_file_name3    => 'filename3.ext'
        );
        */
        
        -- send email now
        utl_smtp_helper.Send(
            p_smtp_conn        => smtp_conn
        );

        -- Disconnect must be invoked to release
        -- resources each connection has been
        -- taken.
        utl_smtp_helper.Disconnect(smtp_conn);
        END IF;
    END;
