apikey = require("./google_api_key")
unirest = require("unirest")
Store = require("./store")

StoreGoogle = (host) ->
  this.root = root = host
  console.log("host: #{root}")
  this.url = (name) -> "#{root}/#{name}"
  this

StoreGoogle.prototype = new Store()
StoreGoogle.prototype.existsSource = (id, cb) ->
  source = "#{id}.gv"
  console.log "http://#{this.url(source)}"
  unirest.head("http://#{this.url(source)}").end (res) ->
    cb(res.status == 200)
StoreGoogle.prototype.writeFile = (name, content, cb) ->
  unirest.post("https://www.googleapis.com/upload/storage/v1/b/#{this.root}/o")
    .type("text/vnd.graphviz")
    .query({
      uploadType: 'media'
      name: name
      predefinedAcl: 'publicRead'
      key: apikey
    }).send(content).end (res) ->
      console.log res
      expect(res.code).toEqual(200)
      cb()
# StoreGoogle.prototype.readFile = (name, cb) ->
#   fs.readFile(this.filepath(name), cb)

module.exports = StoreGoogle