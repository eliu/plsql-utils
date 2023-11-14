SELECT request_id,
       oracle_process_id trace_id,
       req.enable_trace,
       dest.value || '/' || lower(dbnm.value) || '_ora_' ||
       oracle_process_id || '.trc' trace_file,
       prog.user_concurrent_program_name,
       execname.execution_file_name || execname.subroutine_name execution_file_name,
       decode(phase_code, 'R', 'Running') || '-' ||
       decode(status_code, 'R', 'Normal') request_status,
       ses.sid || ',' || ses.serial# "sid-serial#",
       ses.module
  FROM apps.fnd_concurrent_requests    req,
       v$session                       ses,
       v$process                       proc,
       v$parameter                     dest,
       v$parameter                     dbnm,
       apps.fnd_concurrent_programs_vl prog,
       apps.fnd_executables            execname
 WHERE req.request_id = 45095878 --&request
   AND req.oracle_process_id = proc.spid(+)
   AND proc.addr = ses.paddr(+)
   AND dest.name = 'user_dump_dest'
   AND dbnm.name = 'db_name'
   AND req.concurrent_program_id = prog.concurrent_program_id
   AND req.program_application_id = prog.application_id
   AND prog.application_id = execname.application_id
   AND prog.executable_id = execname.executable_id;
