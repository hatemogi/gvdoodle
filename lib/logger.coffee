winston = require "winston"

logger = new (winston.Logger)({
  transports: [
    new (winston.transports.Console)(),
    new (winston.transports.File)({ filename: 'log/app.log' })
  ]
})

module.exports = logger