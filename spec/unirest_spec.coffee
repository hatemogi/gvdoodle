describe 'Unirest for GoogleStorage insert', ->
  unirest = require("unirest")

  it 'post a file', (done) ->
    unirest.post("https://www.googleapis.com/upload/storage/v1/b/store.gvdoodle.com/o")
      .type("text/vnd.graphviz")
      .query({
        uploadType: 'media'
        name: 'object3.gv'
        predefinedAcl: 'publicRead'
        key: 'AIzaSyDXM6n7Hcz2S7uNt3HhBfPutn3f7VE-TUA'
      }).send("digraph T { TE -> ST }")
      .end (res) ->
        # console.log res.body
        expect(res.code).toEqual(200)
        done()

  # it 'metadata put', (done) ->
    # POST https://www.googleapis.com/storage/v1/b/store.gvdoodle.com/o