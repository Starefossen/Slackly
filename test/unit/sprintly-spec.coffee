assert = require 'assert'
turbase = require '../../src/lib/sprintly'

describe.only 'Items', ->
  describe '#getItem', ->
    it 'should return given item', (done) ->
      @timeout 10000

      turbase.getItem '3', (err, status, item) ->
        assert.ifError err

        assert.equal status, 200
        assert.equal item.title, 'API endpoint for aktivtetspåmelding'

        done()

