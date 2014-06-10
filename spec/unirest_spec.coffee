describe 'Unirest for GoogleStorage insert', ->
  unirest = require("unirest")
  apikey = require("../lib/google_api_key")

  it 'post a file with API key', (done) ->
    unirest.post("https://www.googleapis.com/upload/storage/v1/b/store.gvdoodle.com/o")
      # For OAuth2 request use the header below
      # .headers({'Authorization': "Bearer ya29.LgC-t4sIrJRAORsAAAAkIVDJRYWK32hljUhvAKDLmsd09tOcM1VgKNsTpe56UA"})
      .type("text/vnd.graphviz")
      .query({
        uploadType: 'media'
        name: 'object3.gv'
        predefinedAcl: 'publicRead'
        key: apikey
      }).send("digraph T { TE -> ST }")
      .end (res) ->
        # console.log res.body
        expect(res.code).toEqual(200)
        done()