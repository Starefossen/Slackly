assert = require 'assert'

redis = require '../../src/db/redis'
user = require '../../src/lib/user'
slack = require '../../src/lib/slack'
sprintly = require '../../src/lib/sprintly'

getItem = sprintly.getItem
getItemsForUser = sprintly.getItemsForUser

beforeEach (done) ->
  redis.flushall done

afterEach ->
  sprintly.getItem = getItem
  sprintly.getItemsForUser = getItemsForUser

u =
  id: process.env.SPRINTLY_USER_ID
  email: process.env.SPRINTLY_USER
  key: process.env.SPRINTLY_KEY

describe 'Slack', ->
  describe '#parse', ->
    describe 'register', ->
      it 'returns error when user is not registered', (done) ->
        slack.parse 'user1', 'foo', (e, result) ->
          assert.ifError e
          assert.equal result, 'You need to register first!'
          done()

      it 'returns help for invalid params', (done) ->
        slack.parse 'user1', 'register', (e, result) ->
          assert.ifError e
          assert.equal result, '/sprintly register [ID] [EMAIL] [KEY]'
          done()

      it 'saves registered user to database', (done) ->
        cmd = 'register 123 foo bar'
        slack.parse 'user1', cmd, (e, result) ->
          assert.ifError e
          assert.equal result, 'You are now registerd :)'

          user.get 'user1', (e, user) ->
            assert.ifError e
            assert.deepEqual user, id: '123', email: 'foo', key: 'bar'

            done()

    describe 'list', ->
      it 'returns message for no items', (done) ->
        sprintly.getItemsForUser = (user, s, cb) ->
          assert.equal s, 'in-progress'
          cb null, []

        slack.parse u, '', (e, result) ->
          assert.ifError e
          assert.equal result, 'Everything is done! :D'
          done()

      it 'returns items in-progress for user', (done) ->
        sprintly.getItemsForUser = (user, s, cb) ->
          assert.equal s, 'in-progress'
          cb null, [
            product: {}
            items: [
              number: 1
              type: 'task'
              title: 'Item 1'
              product: name: 'Product A'
            ,
              number: 2
              type: 'story'
              title: 'Item 2'
              product: name: 'Product A'
            ]
          ,
            product: {}
            items: [
              number: 3
              type: 'defect'
              title: 'Item 3'
              product: name: 'Product B'
            ]
          ]

        slack.parse u, '', (e, result) ->
          assert.ifError e
          assert.equal result, [
            'Product A #1 [task] Item 1'
            'Product A #2 [story] Item 2'
            'Product B #3 [defect] Item 3'
          ].join '\n'

          done()

    describe 'item', ->
      it 'returns error when item does not exist'
      it 'returns error for unknown status code'
      it 'returns existing item with default product id', (done) ->
        sprintly.getItem = (user, p, n, cb) ->
          assert.equal p, process.env.SPRINTLY_PRODUCT
          assert.equal n, '3'
          cb null, 200, type: 'task', title: 'some task'

        slack.parse u, '#3', (e, result) ->
          assert.ifError e
          assert.equal result, '[task] some task'
          done()

      it 'returns existing item with explicit product id', (done) ->
        sprintly.getItem = (user, p, n, cb) ->
          assert.equal p, '2'
          assert.equal n, '3'
          cb null, 200, type: 'task', title: 'some task'

        slack.parse u, '2#3', (e, result) ->
          assert.ifError e
          assert.equal result, '[task] some task'
          done()

