path = require 'path'
HOME_PATH = process.env.HOME or '/tmp'
DB_PATH = path.resolve HOME_PATH, '.notifyme/config.json'
nconf = require 'nconf'
nconf.file DB_PATH

exports.config = ()->
  nconf
