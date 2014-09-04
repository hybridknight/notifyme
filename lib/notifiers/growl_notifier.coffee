config = require('../config.coffee').config()
growl = require 'growl'

exports.notify = (argv, done_message)->
  growl done_message, title: 'Done'
