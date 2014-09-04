say = require 'say'
Notifer = require './notifier'

module.exports = do ->
  return class VoiceNotifier extends Notifer
    name: 'voice'
    should_be_used: (argv)-> argv.voice
    notify: (argv, message, cb)->
      cb = cb or ->
      voice_map =
        male: 'Alex'
        female: 'Kathy'
      voice = voice_map[argv.voice] || 'Kathy'
      say.speak voice, message, cb

