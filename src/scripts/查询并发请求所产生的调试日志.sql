select msg.log_sequence,
       msg.timestamp,
       substr(msg.module, 1, 70) "MODULE",
       msg.message_text
  from fnd_log_messages msg, fnd_log_transaction_context tcon
 where msg.transaction_context_id = tcon.transaction_context_id
   and tcon.transaction_id = &request_id
   and tcon.transaction_type = 'REQUEST'
   and tcon.component_type = 'CONCURRENT_PROGRAM'
 order by tcon.transaction_context_id desc, log_sequence;
