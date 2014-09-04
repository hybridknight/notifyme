Notifer = require './notifier'
instapush = require 'instapush'

module.exports = do ->
  return class PushNotifier extends Notifer
    name: 'push'
    config_keys: ['instapush_app_id', 'instapush_app_secret']
    should_be_used: (argv)-> argv.push or argv.by == 'push'
    has_invalid_config: (argv)->
      if @config.get('instapush_app_id') and @config.get('instapush_app_secret')
        false
      else
        "Please config #{@config_keys.join(', ')}."
    notify: (argv, message, cb)->
      cb = cb or ->
      instapush.settings
        id: @config.get('instapush_app_id')
        secret: @config.get('instapush_app_secret')
      instapush.notify({
        event: 'task_done'
        trackers:
          message: message
      }, (err, response)->
        if !err
          @log "push notification sent"
          @log response
          cb()
        else
          @log err
          cb(err)
      )
