express = require "express"
dot_runner = require "../lib/dot_runner"
gvid = require "../lib/gvid"
StoreFile = require("../lib/store_file")

store = if process.env.NODE_ENV == 'test'
          new StoreFile("store.test")
        else
          new StoreFile("store")

router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render "editor"

router.get /^\/[0-9A-Z]{5,6}$/, (req, res) ->
  console.log "request for #{req.path}"
  id = req.path.replace(/^\//, '')
  return res.send(404) unless gvid.valid(id)
  store.loadSource id, (err, m, d) ->
    res.render "editor", {meta: m, dot: d}

router.get /^\/[0-9A-Z]{5,6}\.svg$/, (req, res) ->
  res.end "request.svg for #{req.path}"

router.post "/preview.svg", (req, res) ->
  engine = req.body.engine || 'dot'
  console.log "engine: #{engine}"
  dot_runner.run engine, req.body.text, (err, svg) ->
    # console.log ["result", svg]
    res.end svg

module.exports = router
