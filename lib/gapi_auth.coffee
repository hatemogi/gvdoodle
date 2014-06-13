fs = require "fs"
async = require "async"
crypto = require "crypto"
unirest = require "unirest"

token = {
  access_token: null
  expires: 0
}

GapiAuth = (callback) ->
  ts = Math.floor(Date.now() / 1000)
  if token.expires > ts
    console.log "cached access_token"
    callback(null, token.access_token)
  else
    GapiAuth.requestToken (err, t) ->
      return callback(err) if err
      ts = Math.floor(Date.now() / 1000)
      token.expires = t.expires_in + ts
      token.access_token = t.access_token
      callback(null, token.access_token)

GapiAuth.base64url = b64u = (str) ->
  # Base64url = (+ -> -), (/ -> _)
  new Buffer(str).toString("base64")
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .split('=')[0]

GapiAuth.requestToken = (callback) ->
  header = '{"alg":"RS256","typ":"JWT"}'
  claim = {
    iss: "471223684581-3ce8qn4op5cb9qh3dpmtfj84qsk1urmb@developer.gserviceaccount.com"
    scope: "https://www.googleapis.com/auth/devstorage.read_write"
    aud: "https://accounts.google.com/o/oauth2/token"
    exp: Math.floor(Date.now() / 1000) + 3600
    iat: Math.floor(Date.now() / 1000)
  }
  m = "#{b64u header}.#{b64u JSON.stringify claim}"
  async.waterfall [
    (cb) -> fs.realpath(__dirname + "/../conf/gapi_key.pem", cb)
    (path, cb) -> fs.readFile(path, cb)
    (pem, cb) ->
      key = pem.toString()
      sign = b64u crypto.createSign("RSA-SHA256").update(m).sign(key)
      jwt = "#{m}.#{sign}"
      unirest.post("https://accounts.google.com/o/oauth2/token")
        .send({
          'grant_type': "urn:ietf:params:oauth:grant-type:jwt-bearer"
          'assertion': jwt
        }).end (res) ->
          err = if res.code == 200 then null else res.code
          cb(err, res.body)
  ], callback

module.exports = GapiAuth