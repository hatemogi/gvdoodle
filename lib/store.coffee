gvid = require("./gvid")
async = require("async")

Store = -> this

Store.prototype.saveSource = (meta, dot, callback, id_gen) ->
  self = this
  async.retry 10, (cb) ->
    id = (id_gen || gvid)()
    self.existsSource id, (exists) ->
      unless exists
        cb(null, id)
      else
        cb("not exists")
  , (err, id) ->
    if id
      metaJSON = JSON.stringify(meta)
      async.parallel [
        (cb) -> self.writeFile("#{id}.gv", dot, cb)
        (cb) -> self.writeFile("#{id}.meta", metaJSON, cb)
      ], (err) ->
        callback(err, id)
    else
      callback("could not generate proper gvid")

Store.prototype.loadSource = (id, callback) ->
  self = this
  this.existsSource id, (exists) ->
    unless exists
      callback("source not found")
    else
      async.parallel [
        (cb) -> self.readFile("#{id}.meta", cb)
        (cb) -> self.readFile("#{id}.gv", cb)
      ], (err, res) ->
        return callback(err) if err
        meta = res[0]
        mata = JSON.parse(meta) if (typeof meta) == String
        callback(null, res[0], res[1])

module.exports = Store