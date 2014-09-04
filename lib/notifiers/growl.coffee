growl = require 'growl'
Notifer = require './notifier'

module.exports = do ->
  return class GrowlNotifier extends Notifer
    name: 'growl'
    should_be_used: (argv)-> true
    notify: (argv, message, cb)->
      cb = cb or ->
      growl message, title: 'notifyme', cb

