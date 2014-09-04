
# lib/notifiers/notifier.coffee - Notifer base class
module.exports = do ->

  { EventEmitter } = require 'events'

  return class Notifier extends EventEmitter
    log: null
    name: null
    config: require('../config.coffee').config()
    config_keys: []

    constructor: ->
      @name = @constructor.name unless @name
      @log = global.log
    notify: (argv, message, cb) -> cb new Error "no implementation: #{@constructor.name}"
    has_invalid_config: (argv)-> false
    should_be_used: (argv)-> false

