    Hapi = require 'hapi'
    slack = require './lib/slack'

    server = new Hapi.Server()
    server.connection port: 8080, address: '0.0.0.0'

    server.register require('hapi-auth-bearer-token'), (err) ->
      server.auth.strategy 'simple', 'bearer-access-token',
        allowQueryToken: true
        accessTokenName: 'token'
        validateFunc: (token, cb) ->
          return cb null, true, token: token if token is process.env.SLACK_TOKEN
          return cb null, false, token: token

    server.route
      method: 'GET'
      path: '/'
      config: auth: 'simple'
      handler: (request, reply) ->
        slack.parse request.query.text, (err, response) ->
          # @TODO check error?
          reply response

    if not module.parent
      server.start ->
        console.log 'Server started', server.info.uri

    module.exports = server

