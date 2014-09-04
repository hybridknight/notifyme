path = require 'path'
_ = require 'lodash'

config = require('./config.coffee')
notifiers = require './notifiers'
notifiers = _.map notifiers, (notifier)->
  new notifier

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

# setup config keys for all notifiers
CONFIG_KEYS = ['message']
_.each notifiers, (n)->
  CONFIG_KEYS = CONFIG_KEYS.concat n.config_keys if n.config_keys

# setup log filter
global.log = (args...)->
  if argv.debug
    console.log.apply @, args

exports.run = ->
  return console.log require(path.resolve __dirname, "../package.json").version if argv.version

  # setup "--by" command
  if argv.by
    notify_by = argv.by.split ","
    _.each notify_by, (b)->
      argv[b] = argv[b] || true

  log "argv:", argv
  log "notifiers:", _.map notifiers, (n)-> n.name

  if argv._[0] == 'set'
    configs = argv._.slice(1)
    _.map configs, (e)->
      c = e.split "="
      config.config().set c[0], c[1]
      config.config().save (err)->
        console.error err if err
        console.log "#{c[0]}: #{c[1]}"
  else if argv._[0] == 'config'
    config.print(CONFIG_KEYS)
  else
    process.stdin.setEncoding('utf8')
    process.stdin.pipe process.stdout
    process.stdin.on 'end', ->
      done_message = if argv.message then argv.message else config.config().get('message') || 'Task done! yey'

      _.each notifiers, (notifier)->
        if notifier.should_be_used(argv)
          invalid_config = notifier.has_invalid_config(argv)
          if invalid_config
            console.warn "[notifyme] #{notifier.name} has to be configured before using. #{invalid_config}"
          else
            notifier.notify argv, done_message
