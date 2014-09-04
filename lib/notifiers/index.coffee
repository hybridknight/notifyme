#lib/notifiers/index.coffee - Export all modules in this folder as one object
(require 'xrequire')(module, reject: (name) -> name is 'notifier')
