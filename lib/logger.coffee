winston = require "winston"

logger = new (winston.Logger)({
  transports: [
    new (winston.transports.Console)({
      level: "debug"
    }),
    new (winston.transports.File)({
      filename: 'log/app.log'
      maxsize: 8 * 1024 * 1024
      maxFiles: 8
      json: false
      level: "debug"
    })
  ]
})

module.exports = logger