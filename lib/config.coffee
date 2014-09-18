_ = require 'lodash'
path = require 'path'
mkdirp = require 'mkdirp'
HOME_PATH = process.env.HOME or '/tmp'
DB_PATH = path.resolve HOME_PATH, '.notifyme/config.json'
nconf = require 'nconf'

mkdirp.sync path.resolve HOME_PATH, '.notifyme'
nconf.file DB_PATH

exports.config = ()->
  nconf

exports.print = (keys)->
  _.each keys, (key)->
    nconf.get key, (error, value)->
      return console.error error if error
      console.log "#{key}: #{value  || ''}"
