assert = require 'assert'
sprintly = require '../../src/lib/sprintly'

user =
  id: process.env.SPRINTLY_USER_ID
  email: process.env.SPRINTLY_USER
  key: process.env.SPRINTLY_KEY

describe 'Items', ->
  describe '#getItemsForUser', ->
    it 'should return items for user', (done) ->
      @timeout 10000

      status = 'in-progress'
      sprintly.getItemsForUser user, status, (e, items) ->
        assert.ifError e
        assert.deepEqual Object.keys(item), ['product', 'items'] for item in items
        done()

  describe '#getItem', ->
    it 'should return given item', (done) ->
      @timeout 10000

      productId = process.env.SPRINTLY_PRODUCT
      itemNumber = '3'

      sprintly.getItem user, productId, itemNumber, (e, status, item) ->
        assert.ifError e

        assert.equal status, 200
        assert.equal item.title, 'API endpoint for aktivtetspåmelding'

        done()

