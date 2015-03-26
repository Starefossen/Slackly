    request = require 'request'
    async = require 'async'

    STATUSES = ['someday', 'backlog', 'in-progress', 'completed', 'accepted']

    url = (user) ->
      "https://#{user.email}:#{user.key}@sprint.ly/api"

    exports.getItemsForUser = (user, status, cb) ->
      opts = json: true, uri: "#{url user}/products.json"
      request opts, (e, r, products) ->

        async.map products, (product, cb) ->
          return cb null, [] if product.archived

          opts =
            json: true
            uri: "#{url user}/products/#{product.id}/items.json"
            qs: assigned_to: user.id, status: status

          request opts, (e, r, items) ->
            cb e, product: product, items: items

        , cb

    exports.getItem = (user, productId, itemNumber, cb) ->
      opts =
        json: true
        uri: "#{url user}/products/#{productId}/items/#{itemNumber}.json"

      request opts, (e, r, body) ->
        return cb e, r.statusCode, body

