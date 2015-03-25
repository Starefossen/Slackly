assert  = require 'assert'
redis   = require '../../src/db/redis'
user    = require '../../src/lib/user'

beforeEach (done) ->
  redis.flushall done

describe 'User', ->
  describe 'setUser()', ->
    it 'should set new user', (done) ->
      user.set 'foo', 123, 'baz', 'bix', (e) ->
        assert.ifError e

        redis.hgetall 'user:foo', (e, user) ->
          assert.ifError e
          assert.deepEqual user, id: 123, email: 'baz', key: 'bix'
          done()

  describe 'getUser()', ->
    beforeEach (done) ->
      user.set 'foo', 123, 'baz', 'bix', done

    it 'should get existing user', (done) ->
      user.get 'foo', (e, user) ->
        assert.ifError e
        assert.deepEqual user, id: 123, email: 'baz', key: 'bix'
        done()

    it 'should get non existing user', (done) ->
      user.get 'bar', (e, user) ->
        assert.ifError e
        assert.equal user, null
        done()

    it 'should get empty user', (done) ->
      user.get undefined, (e, user) ->
        assert.ifError e
        assert.equal user, null
        done()

