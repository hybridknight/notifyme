growl = require 'growl'

exports.notify = (argv, config, done_message)->
  growl done_message, title: 'Done'
