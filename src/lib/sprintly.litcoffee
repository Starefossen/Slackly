    request = require 'request'

    USER = process.env.SPRINTLY_USER
    KEY  = process.env.SPRINTLY_KEY
    URL  = "https://#{USER}:#{KEY}@sprint.ly/api"

    DEFAULT_PROJECT_ID = process.env.SPRINTLY_PROJECT

    exports.getItem = (id, cb) ->
      if typeof id is 'string' and id.split(':').length is 2
        [projectId, itemNumber] = id.split ':'
      else
        itemNumber = id
        projectId = DEFAULT_PROJECT_ID

      opts =
        json: true
        uri: "#{URL}/products/#{projectId}/items/#{itemNumber}.json"

      request opts, (e, r, body) ->
        return cb e, r.statusCode, body

