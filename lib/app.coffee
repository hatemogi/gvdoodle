express = require("express")
path = require("path")
favicon = require("static-favicon")
appLogger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
routes = require("../routes/index")
users = require("../routes/users")
app = express()

# view engine setup
app.set "views", path.join(__dirname, "../views")
app.set "view engine", "jade"
app.use favicon()
app.use appLogger("dev")

# nginx is handle this feature
app.use (req, res, next) ->
  if req.url.lastIndexOf(".svgz") == req.url.length - 5
    res.set 'Content-Encoding', 'gzip'
  next()

app.use bodyParser.json({limit: '1mb'})
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use express.static(path.join(__dirname, "../public"))
app.use "/", routes
app.use "/users", users

#/ catch 404 and forwarding to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err

#/ error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}


module.exports = app
