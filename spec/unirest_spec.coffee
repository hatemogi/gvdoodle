require("./helper")
describe 'Unirest for GoogleStorage insert', ->
  unirest = require("unirest")
  authToken = require("../lib/gapi_auth")

  it 'post a file with API key', (done) ->
    authToken (err, token) ->
      return done(err) if err
      unirest.post("https://www.googleapis.com/upload/storage/v1/b/store.test.gvdoodle.com/o")
        .headers({'Authorization': "Bearer #{token}"})
        .type("text/vnd.graphviz")
        .query({
          uploadType: 'media'
          name: 'object3.gv'
          predefinedAcl: 'publicRead'
        }).send("digraph T { TE -> ST }")
        .end (res) ->
          expect(res.code).toEqual(200)
          done()