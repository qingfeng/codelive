util = require 'util'
querystring = require 'querystring'
crypto = require 'crypto'
express = require 'express.io'
app = express()
app.http().io()

user_avatar = (user) ->
  if not user
    user
  email = "#{user}@douban.com"
  md5 = crypto.createHash 'md5'
  md5.update email
  normal = "http://img3.douban.com/icon/user_normal.jpg"
  url = "https://secure.gravatar.com/avatar/" + md5.digest('hex')
  q = querystring.stringify({ d: normal, s: 140, r: 'x' })
  url + q

app.io.route 'ready', (req) ->
  channel = req.data.channel
  msg = req.data.msg
  type = req.data.type
  username = req.data.username
  req.io.join channel
  req.io.room(channel).broadcast 'announce', {
    username: username,
    avatar: user_avatar(username),
    type: type,
    message: msg
  }

util.log 'server start'
app.listen 7076