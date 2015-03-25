assert = require 'assert'
sprintly = require '../../src/lib/sprintly'

user =
  id: process.env.SPRINTLY_USER_ID
  email: process.env.SPRINTLY_USER
  key: process.env.SPRINTLY_KEY

describe.only 'Items', ->
  describe '#getItemsForUser', ->
    it 'should return items for user', (done) ->
      @timeout 10000

      productId = process.env.SPRINTLY_PRODUCT
      status = 'in-progress'

      sprintly.getItemsForUser user, productId, status, (e, status, items) ->
        assert.ifError e

        assert.equal status, 200
        assert items instanceof Array

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

