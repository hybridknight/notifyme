growl = require 'growl'

exports.notify = (log, argv, config, done_message)->
  growl done_message, title: 'Done'
