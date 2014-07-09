fs = require("fs")
Store = require("./store")

StoreFile = (relative) ->
  root = fs.realpathSync(__dirname + "/../" + relative)
  this.filepath = (name) -> "#{root}/#{name}"
  this

StoreFile.prototype = new Store()
StoreFile.prototype.existsSource = (id, cb) ->
  fs.exists this.filepath("#{id}.gv"), cb
StoreFile.prototype.writeFile = (name, content, cb) ->
  fs.writeFile(this.filepath(name), content, cb)
StoreFile.prototype.readFile = (name, cb) ->
  fs.readFile(this.filepath(name), cb)

module.exports = StoreFile
