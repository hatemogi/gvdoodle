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
        callback(null, JSON.parse(res[0].toString()), res[1].toString())

module.exports = Store