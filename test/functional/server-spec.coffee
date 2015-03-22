assert = require 'assert'
server = require '../../src/server'

describe 'Server', ->
  it 'should return 404', (done) ->
    server.inject '/', (res) ->
      assert.equal res.result.statusCode, 404
      assert.equal res.result.error, 'Not Found'
      done()

