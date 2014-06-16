express = require "express"
dot_runner = require "../lib/dot_runner"
gvid = require "../lib/gvid"
StoreFile = require("../lib/store_file")
StoreGoogle = require("../lib/store_google")
logger = require("../lib/logger")

storeFileFactory = ->
  if process.env.NODE_ENV == 'test'
    new StoreFile("store.test")
  else
    new StoreFile("store")

storeGoogleFactory = ->
  google = (host) ->
    logger.info("storeGoogle is ready for #{host}")
    new StoreGoogle(host)
  if process.env.NODE_ENV == 'test'
    google "store.test.gvdoodle.com"
  else
    google "store.gvdoodle.com"

# store = storeFileFactory()
store = storeGoogleFactory()

router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render "editor"

router.get /^\/[0-9A-Z]{5,6}$/, (req, res) ->
  logger.debug "request for #{req.path}"
  id = req.path.replace(/^\//, '')
  return res.send(404) unless gvid.valid(id)
  res.render "editor", {gvid: id}

router.get /^\/[0-9A-Z]{5,6}\.svg$/, (req, res) ->
  res.end "request.svg for #{req.path}"

router.post "/preview", (req, res) ->
  engine = req.body.engine || 'dot'
  logger.debug "engine: #{engine}"
  dot_runner.preview engine, req.body.text, (err, svg) ->
    # console.log ["result", svg]
    res.end svg

router.post "/publish", (req, res) ->
  id = gvid()
  res.redirect("/#{id}")

module.exports = router
