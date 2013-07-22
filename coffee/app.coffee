util = require 'util'
querystring = require 'querystring'
crypto = require 'crypto'
express = require 'express.io'
redis = require 'redis'
app = express()
app.http().io()

user_avatar = (user) ->
  email = "#{user}@douban.com"
  md5 = crypto.createHash 'md5'
  md5.update email
  normal = "http://img3.douban.com/icon/user_normal.jpg"
  url = "https://secure.gravatar.com/avatar/" + md5.digest('hex')
  q = querystring.stringify({ d: normal, s: 140, r: 'x' })
  url + q

app.io.route 'ready', (req) ->
  channel = req.data.channel
  util.log 'new user in this page: ' + channel
  req.io.join channel

client = redis.createClient()
client.subscribe('codelive')

client.on 'message', (channel, data) ->
  message = JSON.parse(data)
  io_channel = message.channel
  util.log 'io_channel: ' + io_channel
  msg = message.action_data
  util.log 'msg: ' + msg
  username = JSON.parse(msg).author
  util.log 'username: ' + username
  app.io.room(io_channel).broadcast 'announce', {
    avatar: user_avatar(username),
    send_message: msg
  }

util.log 'server start'
app.listen 7076
