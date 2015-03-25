    user = require './user'
    sprintly = require './sprintly'

    exports.parse = (u, cmd, cb) ->
      cmd = cmd.trim().split ' '

      if typeof u is 'string' and not /^register/.test cmd[0]
        return cb null, 'You need to register first!'

      switch cmd[0]
        when 'register'
          if cmd.length isnt 4
            return cb null, '/sprintly register [ID] [EMAIL] [KEY]'

          user.set u, cmd[1], cmd[2], cmd[3], (e) ->
            return cb e if e
            return cb null, 'You are now registerd :)'

        when '', 'list'
          productId = process.env.SPRINTLY_PRODUCT
          status = 'in-progress'
          sprintly.getItemsForUser u, productId, status, (e, s, items) ->
            return cb e if e
            return cb null, 'Everything is done! :D' if items.length is 0

            res = []
            for item in items
              res.push "[#{item.type}] #{item.title}"

            return cb null, res.join '\n'

        else
          if /[A-Z0-9]*#[0-9]+/.test cmd[0]
            [productId, itemNumber] = cmd[0].split '#'
            productId = process.env.SPRINTLY_PRODUCT if not productId

            sprintly.getItem u, productId, itemNumber, (e, s, item) ->
              return cb e if e

              if s is 404
                return cb null, 'Sorry, that item does not exist :('

              if s isnt 200
                return cb null, "Sprint.ly returned status code #{s}"

              return cb null, "[#{item.type}] #{item.title}"

          else
            return cb new Error "Unknown command #{cmd[0]}"

