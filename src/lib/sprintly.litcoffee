    request = require 'request'

    STATUSES = ['someday', 'backlog', 'in-progress', 'completed', 'accepted']

    url = (user) ->
      "https://#{user.email}:#{user.key}@sprint.ly/api"

    exports.getItemsForUser = (user, productId, status, cb) ->
      opts =
        json: true
        uri: "#{url user}/products/#{productId}/items.json"
        qs: assigned_to: user.id, status: status

      request opts, (e, r, body) ->
        return cb e, r.statusCode, body

    exports.getItem = (user, productId, itemNumber, cb) ->
      opts =
        json: true
        uri: "#{url user}/products/#{productId}/items/#{itemNumber}.json"

      request opts, (e, r, body) ->
        return cb e, r.statusCode, body

