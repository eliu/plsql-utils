-- Find all responsibilities that can access
-- specific concurrent program.
SELECT rsp.responsibility_name,
       grp.request_group_name,
       prg.*
  FROM fnd_responsibility_vl rsp,
       fnd_request_groups    grp,
       fnd_request_group_units gpu,
       fnd_concurrent_programs_vl prg
 WHERE rsp.request_group_id = grp.request_group_id
   AND rsp.application_id = grp.application_id
   AND grp.request_group_id = gpu.request_group_id
   AND grp.application_id = gpu.application_id
   AND gpu.unit_application_id = prg.application_id
   AND gpu.request_unit_id = prg.concurrent_program_id
   AND prg.concurrent_program_name = '&CONC_PROGRAM_NAME';
