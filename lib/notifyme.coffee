# locate configurations file
path = require 'path'
HOME_PATH = process.env.HOME or '/tmp'
DB_PATH = path.resolve HOME_PATH, '.notifyme/config.json'
nconf = require 'nconf'
nconf.file DB_PATH

_ = require 'lodash'

voice_notifier = require './notifiers/voice_notifier.coffee'
growl_notifier = require './notifiers/growl_notifier.coffee'
sms_notifier = require './notifiers/sms_notifier.coffee'

argv = require('minimist')(process.argv.slice(2),
  default:
    growl: true
    sms: null
    voice: null
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
    vv: "version"
    v: "voice"
  boolean: ['debug', 'version']
  )

CONFIG_KEYS = ['message', 'phone_number', 'twilio_sid', 'twilio_auth_token', 'twilio_phone_number']

log = (args...)->
  if argv.debug
    console.log.apply @, args

exports.run = ->
  log "argv:", argv
  return console.log require(path.resolve __dirname, "../package.json").version if argv.version
  if argv.by
    notify_by = argv.by.split ","
    _.each notify_by, (b)->
      argv[b] = true
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
      done_message = if argv.message then argv.message else nconf.get('message') || 'Task done! yey'
      growl_notifier.notify log, argv, nconf, done_message
      if argv.sms or argv.by == 'sms'
        sms_notifier.notify log, argv, nconf, done_message
      if argv.voice
        voice_notifier.notify log, argv, nconf, done_message
