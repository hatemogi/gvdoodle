fs = require("fs")
Store = require("./store")

_ROOT = fs.realpathSync(__dirname + "/../store")
filename = (name) -> "#{_ROOT}/#{name}"

store_file = new Store({
  existsSource: (id) -> fs.existsSync filename("#{id}.gv")
  writeFile: (name, content, cb) ->
    fs.writeFile(filename(name), content, cb)
  readFile: (name, cb) ->
    fs.readFile(filename(name), cb)
})

module.exports = store_file