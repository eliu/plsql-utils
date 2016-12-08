SELECT fscpvl.parameter_name,
       fscpvl.display_name,
       decode(fscpvl.parameter_name, 'OUTBOUND_SSL_ENABLED',
              decode(fscpval.parameter_value, 'N',
                     'Value "' || fscpval.parameter_value || '" with smtp port "25"',
                     'Value "' || fscpval.parameter_value || '" with smtp port "465"'),
              fscpval.parameter_value) parameter_value,
       fscpvl.description
  FROM fnd_svc_comp_params_vl  fscpvl,
       fnd_svc_comp_param_vals fscpval
 WHERE fscpval.parameter_id = fscpvl.parameter_id
   AND fscpvl.COMPONENT_TYPE = 'WF_MAILER'
   AND fscpvl.parameter_name IN
       ('REPLYTO',
        'OUTBOUND_PROTOCOL',
        'OUTBOUND_SERVER',
        'OUTBOUND_SSL_ENABLED');
