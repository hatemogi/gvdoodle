gvid = require("./gvid")
async = require("async")

Store = (handler) ->
  this.saveSource = (meta, dot, callback, id_gen) ->
    for _ in [0..10]
      id = (id_gen || gvid)()
      continue if handler.existsSource(id)
      metaJSON = JSON.stringify(meta)
      async.parallel [
        (cb) -> handler.writeFile("#{id}.gv", dot, cb)
        (cb) -> handler.writeFile("#{id}.meta", metaJSON, cb)
      ], (err) ->
        callback(err, id)
      return id
    callback("could not generate proper gvid")

  this.existsSource = handler.existsSource

  this.loadSource = (id, callback) ->
    return callback("not exists") unless handler.existsSource(id)
    async.parallel [
      (cb) -> handler.readFile("#{id}.meta", cb)
      (cb) -> handler.readFile("#{id}.gv", cb)
    ], (err, res) ->
      callback(err, JSON.parse(res[0].toString()), res[1].toString())

  this.saveFile = handler.writeFile
  this

module.exports = Store