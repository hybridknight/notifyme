notifyme
========

Notify me when task is done. This thing can pop a Growl notification, send an SMS to your mobile, and even speak to you.

Installation
---
You will need node v0.10.31 and npm v1.3.14 (comes with node) or a more recent version in order to start using it.

Install [growlnotify(1)](http://growl.info/extras.php#growlnotify). On OS X 10.8, Notification Center is supported using [terminal-notifier](https://github.com/alloy/terminal-notifier). To install:

      $ sudo gem install terminal-notifier

See: [node-growl](https://github.com/visionmedia/node-growl)

Once you have node and npm on your machine, install with:

    $ npm install -g notifyme

Configurations
---
To use SMS notification, you need to have [Twilio](https://www.twilio.com/try-twilio) account to use their API.

Use `set` command to set configuration:

    $ notifyme set key=value

Available configurations:
- *message* - message to show when task is don
- *phone_number* - message will be sent to this number
- *twilio_sid* - Twilio SID
- *twilio_auth_token* - Twilio Auth Token
- *twilio_phone_number* - Twilio Phone Number

You can configure multiple keys by:

    $ notifyme set key1=value1 key2=value2 ...

Use `config` command to show all config:

    $ notifyme config

Usage
---

    $ long-running task | notifyme [options]

**notifyme** reads stdin and pipe it to stdout while taks is running. After task is done, notification message specified in options will be sent.

    $ long-running task | notifyme --by=sms

Notify by SMS to cofigured phone number. Growl notification is the default method.

    $ long-running task | notifyme --sms=66613334221

Overide configured phone number and use `66613334221` instead.

    --by        Select notification method eg. sms
    --sms       Send SMS to this number instead of using configured number
    --growl     Turn on/off Growl notification
    --message   Custom notification message
    --debug     Enable debug mode
    --version   Show version

License
---
The MIT License (MIT)
