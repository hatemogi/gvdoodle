require("./helper")
crypto = require "crypto"
bases = require "bases"
fs = require "fs"
unirest = require "unirest"

describe 'Google JWS', ->
  # google_auth = require("../lib/google_auth")

  base64url = (str) ->
    # Base64url = (+ -> -), (/ -> _)
    new Buffer(str).toString("base64")
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .split('=')[0]

  it '신규발급 테스트', (done) ->
    header = '{"alg":"RS256","typ":"JWT"}'
    expect(base64url(header)).toEqual 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9'
    claim = {
      iss: "471223684581-3ce8qn4op5cb9qh3dpmtfj84qsk1urmb@developer.gserviceaccount.com"
      scope: "https://www.googleapis.com/auth/devstorage.read_write"
      aud: "https://accounts.google.com/o/oauth2/token"
      exp: Math.floor((Date.now() + 3000) / 1000)
      iat: Math.floor(Date.now() / 1000)
    }
    m = "#{base64url header}.#{base64url JSON.stringify claim}"
    key = fs.readFileSync("conf/gapi_key.pem").toString()
    sign = base64url crypto.createSign("RSA-SHA256").update(m).sign(key)
    jwt = "#{m}.#{sign}"
    unirest.post("https://accounts.google.com/o/oauth2/token")
      .send({
        'grant_type': "urn:ietf:params:oauth:grant-type:jwt-bearer"
        'assertion': jwt
      }).end (res) ->
        console.log(res.body)
        if (res.code == 200)
          console.log res.body.access_token
        done()
