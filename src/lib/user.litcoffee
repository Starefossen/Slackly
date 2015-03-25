    redis = require '../db/redis'

    exports.get = (userName, cb) ->
      redis.hgetall "user:#{userName}", (err, user) ->
        cb null, user

    exports.set = (userName, id, email, key, cb) ->
      redis.del "user:#{userName}"
      redis.hmset "user:#{userName}", id: id, email: email, key: key, (err) ->
        cb err

