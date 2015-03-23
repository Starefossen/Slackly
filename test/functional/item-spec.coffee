assert = require 'assert'
server = require '../../src/server'

describe 'Item', ->
  it 'should return data for simple item', (done) ->
    @timeout 10000
    cmd = '3'
    server.inject "/?token=abc123&text=#{cmd}", (res) ->
      assert.equal res.statusCode, 200
      assert.equal res.result, '[task] API endpoint for aktivtetspåmelding'

      done()

  it 'should return data for project item', (done) ->
    @timeout 10000
    cmd = '29494:3'
    server.inject "/?token=abc123&text=#{cmd}", (res) ->
      assert.equal res.statusCode, 200
      assert.equal res.result, '[task] Memcached Docker container is set up'

      done()

