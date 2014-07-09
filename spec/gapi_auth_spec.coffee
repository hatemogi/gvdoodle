describe 'GAPI token', ->
  authToken = require("../lib/gapi_auth")

  it 'requests a token', (done) ->
    authToken (err, token) ->
      expect(token[0..4]).toEqual "ya29."
      done(err)
