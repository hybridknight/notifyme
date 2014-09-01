path = require 'path'
HOME_PATH = process.env.HOME or '/tmp'
DB_PATH = path.resolve HOME_PATH, '.notifyme/config.json'

argv = require('minimist')(process.argv.slice(2),
  default:
    growl: true
    sms: null
    debug: false
    by: null
    message: null
    version: false
  alias:
    d: "debug"
    g: "growl"
    s: "sms"
    b: "by"
    m: "message"
    v: "version"
  )

growl = require 'growl'
command = process.argv.slice(2).join " "
nconf = require 'nconf'
nconf.file DB_PATH
_ = require 'lodash'
Q = require 'q'
twilio = require('twilio')(nconf.get('twilio_sid'), nconf.get('twilio_auth_token'))

CONFIG_KEYS = ['phone_number', 'twilio_sid', 'twilio_auth_token', 'twilio_phone_number']

log = (args...)->
  if argv.debug
    console.log.apply @, args

exports.run = ->
  log argv
  log process.argv
  return console.log require(path.resolve __dirname, "../package.json").version if argv.version
  if argv._[0] == 'set'
    config = argv._.slice(1)
    _.map config, (e)->
      c = e.split "="
      nconf.set c[0], c[1]
      nconf.save (err)->
        console.error err if err
        console.log "#{c[0]}: #{c[1]}"
  else if argv._[0] == 'config'
    _.each CONFIG_KEYS, (key)->
      nconf.get key, (error, value)->
        return console.error error if error
        console.log "#{key}: #{value}"
  else
    process.stdin.setEncoding('utf8')
    process.stdin.pipe process.stdout
    process.stdin.on 'end', ->
      done_message = if argv.message then argv.message else nconf.get('sms_message') || 'Task done! yey'
      growl done_message, title: 'Done'
      if argv.sms or argv.by == 'sms'
        sms_to = if argv.sms then "+#{argv.sms}" else "+#{nconf.get('phone_number')}"
        twilio.sendMessage({
          to: sms_to
          from: nconf.get 'twilio_phone_number'
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
