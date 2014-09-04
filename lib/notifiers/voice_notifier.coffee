say = require 'say'

exports.notify = (argv, config, done_message)->
  voice_map =
    male: 'Alex'
    female: 'Kathy'
  voice = voice_map[argv.voice] || 'Kathy'
  say.speak voice, done_message
