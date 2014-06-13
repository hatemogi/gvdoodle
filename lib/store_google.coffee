unirest = require("unirest")
Store = require("./store")
authToken = require("./gapi_auth")

StoreGoogle = (host) ->
  this.root = root = host
  console.log("host: #{root}")
  this.url = (name) -> "#{root}/#{name}"
  this

StoreGoogle.prototype = new Store()
StoreGoogle.prototype.existsSource = (id, cb) ->
  source = "#{id}.gv"
  unirest.head("http://#{this.url(source)}").end (res) ->
    cb(res.status == 200)

StoreGoogle.prototype.writeFile = (name, content, cb) ->
  root = this.root
  authToken((err, token) ->
    return cb(err) if err
    unirest.post("https://www.googleapis.com/upload/storage/v1/b/#{root}/o")
      .headers({"Authorization": "Bearer #{token}"})
      .type("text/vnd.graphviz")
      .query({
        uploadType: 'media'
        name: name
        predefinedAcl: 'publicRead'
      }).send(content).end (res) ->
        return cb("writeFile: #{res.code}") unless res.code == 200
        cb()
  )
StoreGoogle.prototype.readFile = (name, cb) ->
  unirest.get("http://#{this.url(name)}").end (res) ->
    return cb("StoreGoogle.readFile: #{res.code}") unless res.code == 200
    cb(null, res.body)

module.exports = StoreGoogle