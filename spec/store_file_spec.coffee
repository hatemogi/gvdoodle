describe 'Store (File)', ->
  store = require("../lib/store_file")
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
        expect(store.existsSource(id)).toBeTruthy()
        store.loadSource(id, cb)
      (m, d, cb) ->
        expect(d).toEqual dot
        expect(m).toEqual meta
        cb()
    ], done
