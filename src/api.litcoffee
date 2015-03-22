    sprintly = require './lib/sprintly'

    exports.register = (server, options, next) ->
      server.route [
        method: 'GET'
        path: "#{options.route.prefix}/item"
        config: auth: 'simple'
        handler: (request, reply) ->
          cmd = request.query.text.trim().split ' '

          if cmd.length is 1
            sprintly.getItem cmd[0], (e, s, item) ->
              reply "[#{item.type}] #{item.title}"

          else if cmd.length is 2
            reply 'Sorry, item action is not implemented yet..'

          else
            reply 'Sorry, I did not understand that!'
      ]

      next()

    exports.register.attributes =
      name: 'api'
      version: '1.0.0'

