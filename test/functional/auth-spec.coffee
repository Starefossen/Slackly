assert = require 'assert'
server = require '../../src/server'

describe 'Auth', ->
  it 'should return 401 for missing token', (done) ->
    server.inject '/', (res) ->
      assert.equal res.statusCode, 401
      assert.deepEqual res.result,
        statusCode: 401
        error: 'Unauthorized'
        message: 'Missing authentication'

      done()

  it 'should return 401 for bad token', (done) ->
    server.inject '/?token=foo', (res) ->
      assert.equal res.statusCode, 401
      assert.deepEqual res.result,
        statusCode: 401
        error: 'Unauthorized'
        message: 'Bad token'

      done()

