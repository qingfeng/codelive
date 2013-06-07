util = require 'util'
express = require 'express.io'
app = express()
app.http().io()

app.io.route 'ready', (req) ->
  channel = req.data.channel
  msg = req.data.msg
  req.io.join channel
  req.io.room(channel).broadcast 'announce', {
    message: msg
  }

util.log 'server start'
app.listen 7076