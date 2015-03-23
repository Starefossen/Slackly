    sprintly = require './sprintly'

    exports.parse = (cmd, cb) ->
      cmd = cmd.trim().split ' '

      if cmd.length is 1
        sprintly.getItem cmd[0], (e, s, item) ->
          cb null, "[#{item.type}] #{item.title}"

      else if cmd.length is 2
        cb null, 'Sorry, item action is not implemented yet..'

      else
        cb null, 'Sorry, I did not understand that!'

