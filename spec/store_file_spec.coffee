describe 'Store (File)', ->
  StoreFile = require("../lib/store_file")
  store = new StoreFile("store.test")
  gvid = require("../lib/gvid")
  async = require("async")

  it 'save & load source', (done) ->
    meta = {layout: 'dot', seed: Math.random()}
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
