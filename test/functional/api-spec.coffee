assert = require 'assert'
server = require '../../src/server'

describe '/api', ->
  describe '/item', ->
    it 'should return 401 for missing token', (done) ->
      server.inject '/api/item', (res) ->
        assert.equal res.statusCode, 401
        assert.deepEqual res.result,
          statusCode: 401
          error: 'Unauthorized'
          message: 'Missing authentication'

        done()

    it 'should return 401 for bad token', (done) ->
      server.inject '/api/item?token=foo', (res) ->
        assert.equal res.statusCode, 401
        assert.deepEqual res.result,
          statusCode: 401
          error: 'Unauthorized'
          message: 'Bad token'

        done()

    it 'should return data for simple item', (done) ->
      @timeout 5000
      server.inject '/api/item?token=abc123&text=3', (res) ->
        assert.equal res.statusCode, 200
        assert.equal res.result, '[task] API endpoint for aktivtetspåmelding'

        done()

    it 'should return data for project item', (done) ->
      @timeout 5000
      server.inject '/api/item?token=abc123&text=29494:3', (res) ->
        assert.equal res.statusCode, 200
        assert.equal res.result, '[task] Memcached Docker container is set up'

        done()

