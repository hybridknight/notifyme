notifyme
========

Notify me when task is done. This thing can pop a Growl notification, send an SMS/push notification to your mobile, and even speak to you.

Installation
===
You will need node v0.10.31 and npm v1.3.14 (comes with node) or a more recent version in order to start using it.

Once you have node and npm on your machine, install with:

    $ npm install -g notifyme

Notifications
===

Voice
---
You need to have OSX text to speech available on your machine.

Growl
---
Install [growlnotify(1)](http://growl.info/extras.php#growlnotify). On OS X 10.8, Notification Center is supported using [terminal-notifier](https://github.com/alloy/terminal-notifier). To install:

      $ sudo gem install terminal-notifier

See: [node-growl](https://github.com/visionmedia/node-growl)

SMS via Twilio
---
To use SMS notification, you need to have [Twilio](https://www.twilio.com/try-twilio) account to use their API.

Push notification via Instapush
---
And to use Push notification, you need to have [Instapush](https://instapush.im) account to use their API. Add an application then add new `Event` with following template:

`Event Title`: `task_done`

`Trackers`: `message`

`Push Message`: `{message}`

Configurations
===

Use `set` command to set configuration:

    $ notifyme set key=value

You can configure multiple keys by:

    $ notifyme set key1=value1 key2=value2 ...

Available configurations:
- *message* - Message to be sent when task is done
- *phone_number* - [SMS] Message will be sent to this phone number
- *twilio_sid* - [SMS] Twilio SID
- *twilio_auth_token* - [SMS] Twilio Auth Token
- *twilio_phone_number* - [SMS] Twilio Phone Number
- *instapush_app_id* - [Push notification] Instapush application id
- *instapush_app_secret* - [Push notification] Instapush application secret

Use `config` command to show all config:

    $ notifyme config

Usage
===

    $ long-running task | notifyme [options]

**notifyme** reads stdin and pipes it to stdout while task is running. After task is done, notification message specified in options will be sent.

    $ long-running task | notifyme --by=sms

Notify by SMS to configured phone number. Growl notification is the default method.

    $ long-running task | notifyme --sms=66613334221

Overide configured phone number and use `66613334221` instead.

    --by        Select notification method e.g. sms, voice, growl, ex. "sms,voice"
    --sms       Send SMS to this number instead of using configured number or just "--sms" to use configured number
    --voice     Notify by voice eg. male, female
    --growl     Turn on/off Growl notification
    --message   Custom notification message
    --debug     Enable debug mode
    --version   Show version

License
===
The MIT License (MIT)
