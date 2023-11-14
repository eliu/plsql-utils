SELECT top_req.request_id                    request_set_id
      ,top_prog.user_concurrent_program_name request_set_name
      ,sub_req.request_id                    sub_request_id
      ,sub_prog.user_concurrent_program_name sub_request
      ,sub_req.argument_text
      ,sub_req.actual_start_date
      ,sub_req.actual_completion_date
FROM   fnd_concurrent_requests    sub_req
      ,fnd_concurrent_programs_vl sub_prog
      ,fnd_concurrent_requests    top_req
      ,fnd_concurrent_programs_vl top_prog
WHERE  sub_req.program_application_id = sub_prog.application_id
AND    sub_req.concurrent_program_id = sub_prog.concurrent_program_id
AND    sub_req.request_type = 'P' -- A: Application, S: Set, P: Program in lookup SRS_REQUEST_UNIT_TYPES
AND    sub_req.priority_request_id = top_req.request_id
AND    top_req.program_application_id = top_prog.application_id
AND    top_req.concurrent_program_id = top_prog.concurrent_program_id
AND    top_req.request_type = 'M'
AND    top_req.request_id = 754025 --&top_request_id
ORDER  BY sub_req.request_id;
