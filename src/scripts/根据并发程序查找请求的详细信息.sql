SELECT req.request_id,
       decode(req.parent_request_id, -1, NULL, req.parent_request_id) parent_request_id,
       fcp_tl.user_concurrent_program_name,
       fcp.concurrent_program_name,
       trim(pc.meaning) phase,
       trim(sc.meaning) status,
       usr.user_name requestor,
       req.request_date,
       req.actual_start_date,
       req.actual_completion_date,
       req.argument_text
  FROM apps.fnd_concurrent_programs    fcp,
       apps.fnd_concurrent_programs_tl fcp_tl,
       apps.fnd_concurrent_requests    req,
       apps.fnd_lookup_values          pc,
       apps.fnd_lookup_values          sc,
       apps.fnd_user                   usr
 WHERE fcp.application_id = req.program_application_id
   AND fcp.concurrent_program_id = req.concurrent_program_id
   AND fcp.enabled_flag = 'Y'
   AND fcp_tl.APPLICATION_ID = fcp.APPLICATION_ID
   AND fcp_tl.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
   AND fcp_tl.language = 'ZHS'
   AND pc.lookup_type = 'CP_PHASE_CODE'
   AND pc.language = 'ZHS'
   AND pc.LOOKUP_CODE = DECODE(sc.LOOKUP_CODE,
                                  'H',
                                  'I',
                                  'S',
                                  'I',
                                  'U',
                                  'I',
                                  'M',
                                  'I',
                                  Req.PHASE_CODE)
   AND pc.view_application_id = 0
   AND sc.lookup_type = 'CP_STATUS_CODE'
   AND SC.language = 'ZHS'
   AND sc.LOOKUP_CODE =
       DECODE(Req.PHASE_CODE,
              'P',
              DECODE(Req.HOLD_FLAG,
                     'Y',
                     'H',
                     DECODE(fcp.ENABLED_FLAG,
                            'N',
                            'U',
                            DECODE(SIGN(Req.REQUESTED_START_DATE - SYSDATE),
                                   1,
                                   'P',
                                   Req.STATUS_CODE))),
              'R',
              DECODE(Req.HOLD_FLAG,
                     'Y',
                     'S',
                     DECODE(Req.STATUS_CODE, 'Q', 'B', 'I', 'B', Req.STATUS_CODE)),
              Req.STATUS_CODE)
   AND sc.view_application_id = 0
   AND req.requested_by = usr.user_id
;
