describe 'Store (Google)', ->
  StoreGoogle = require("../lib/store_google")
  HOST = "store.test.gvdoodle.com"
  store = new StoreGoogle(HOST)
  gvid = require("../lib/gvid")
  async = require("async")
  unirest = require("unirest")

  it 'save & load source', (done) ->
    meta = {engine: 'dot', seed: Math.random()}
    dot = "digraph { A-> B#{Math.floor(Math.random() * 100)} }"
    async.waterfall [
      (cb) ->
        store.saveSource meta, dot, cb
      (id, cb) ->
        expect(gvid.valid(id)).toBeTruthy()
        store.existsSource(id, (exists) ->
          expect(exists).toBeTruthy()
        )
        store.loadSource(id, cb)
      (m, d, cb) ->
        expect(d).toEqual dot
        expect(m).toEqual meta
        cb()
    ], done
  it 'saves a svg file with proper mime-type', (done) ->
    store.writeFile 'TEST6.svg', new Buffer('<svg></svg>'), (err) ->
      return done(err) if err
      unirest.get "http://#{HOST}/TEST6.svg", (res) ->
        expect(res.status).toBe(200)
        expect(res.headers["content-type"]).toEqual("image/svg+xml")
        done()
