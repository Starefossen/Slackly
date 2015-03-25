assert = require 'assert'

redis = require '../../src/db/redis'
server = require '../../src/server'

user_name = 'user1'
user =
  id: process.env.SPRINTLY_USER_ID
  email: process.env.SPRINTLY_USER
  key: process.env.SPRINTLY_KEY

before (done) ->
  redis.flushall done

describe 'Register', ->
  it 'registers user', (done) ->
    @timeout 10000

    cmd = "register #{user.id} #{user.email} #{user.key}"
    server.inject "/?token=abc123&user_name=#{user_name}&text=#{cmd}", (res) ->
      assert.equal res.statusCode, 200
      assert.equal res.result, 'You are now registerd :)'
      done()

describe 'List', ->
  it 'returns list of items', (done) ->
    @timeout 10000

    cmd = ''
    server.inject "/?token=abc123&user_name=#{user_name}&text=#{cmd}", (res) ->
      assert.equal res.statusCode, 200
      assert.equal typeof res.result, 'string'
      done()

describe 'Item', ->
  it 'returns details for item', (done) ->
    @timeout 10000

    cmd = '%233'
    server.inject "/?token=abc123&user_name=#{user_name}&text=#{cmd}", (res) ->
      assert.equal res.statusCode, 200
      assert.equal res.result, '[task] API endpoint for aktivtetspåmelding'
      done()

