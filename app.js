// Generated by CoffeeScript 1.6.3
var app, crypto, express, querystring, user_avatar, util;

util = require('util');

querystring = require('querystring');

crypto = require('crypto');

express = require('express.io');

app = express();

app.http().io();

user_avatar = function(user) {
  var email, md5, normal, q, url;
  email = "" + user + "@douban.com";
  md5 = crypto.createHash('md5');
  md5.update(email);
  normal = "http://img3.douban.com/icon/user_normal.jpg";
  url = "https://secure.gravatar.com/avatar/" + md5.digest('hex');
  q = querystring.stringify({
    d: normal,
    s: 140,
    r: 'x'
  });
  return url + q;
};

app.io.route('ready', function(req) {
  var channel;
  channel = req.data.channel;
  util.log("new user in this page: " + channel);
  req.io.join(channel);
});

var redis = require('redis');
client = redis.createClient();
client.subscribe('codelive');
client.on('message', function(channel, message) {
  var message = JSON.parse(message);
  var io_channel = message.channel;
  util.log("io channel: " + io_channel);
  var msg = message.action_data;
  util.log("send message: " + msg);
  var username = JSON.parse(msg).author;
  util.log("username: " + username);
  app.io.room(io_channel).broadcast('announce', {
    avatar: user_avatar(username),
    send_message: msg
  });
});

util.log('server start');

app.listen(7076);
