exports.notify = (argv, config, done_message)->
  if config.get('twilio_sid') and config.get('twilio_auth_token') and config.get('twilio_phone_number')
    twilio = require('twilio')(config.get('twilio_sid'), config.get('twilio_auth_token'))
  else
    twilio = null

  return console.warn "Cannot send SMS. Please reconfigure Twilio." unless twilio

  sms_to = if argv.sms and argv.sms isnt true then "+#{argv.sms}" else "+#{config.get('phone_number')}"
  twilio.sendMessage({
    to: sms_to
    from: config.get 'twilio_phone_number'
    body: done_message
  }, (err, responseData)->
    if !err
      log "sms sent"
      log "to:", responseData.to
      log "form:", responseData.from
      log "body:", responseData.body
    else
      log err
  )
