require("./helper")
zlib = require "zlib"
fs = require "fs"

describe 'zlib', ->
  it 'gzip, gunzip', (done) ->
    zlib.gzip "buffer", (err, result) ->
      expect(err).toBe null
      fs.writeFile "store.test/zlib.gz", result, (err, result) ->
        expect(err).toBe null
      zlib.gunzip result, (err, deflate) ->
        expect(err).toBe null
        done(err)
