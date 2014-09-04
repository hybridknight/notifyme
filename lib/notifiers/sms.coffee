Notifer = require './notifier'

module.exports = do ->
  return class SMSNotifier extends Notifer
    name: 'sms'
    has_config_keys: ['phone_number', 'twilio_sid', 'twilio_auth_token', 'twilio_phone_number']
    should_be_used: (argv)-> argv.sms or argv.by == 'sms'
    has_invalid_config: (argv)->
      if @config.get('twilio_sid') and @config.get('twilio_auth_token') and @config.get('twilio_phone_number')
        false
      else
        "Please config #{@has_config_keys.join(', ')}."
    notify: (argv, message, cb)->
      cb = cb or ->
      twilio = require('twilio')(@config.get('twilio_sid'), @config.get('twilio_auth_token'))
      sms_to = if argv.sms and argv.sms isnt true then "+#{argv.sms}" else "+#{@config.get('phone_number')}"
      twilio.sendMessage({
        to: sms_to
        from: @config.get 'twilio_phone_number'
        body: message
      }, (err, responseData)->
        if !err
          @log "sms sent"
          @log "to:", responseData.to
          @log "form:", responseData.from
          @log "body:", responseData.body
          cb()
        else
          @log err
          cb(err)
      )
