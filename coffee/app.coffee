express = require 'express.io'
app = express()
app.http.io()

app.io.route 'ready', (req) ->
    req.io.join req.data
    req.io.room req.data.broadcast 'announce', {
        message: 'New client in the ' + req.data + ' room. '
    }

app.get '/', (req, res) ->
    res.sendfile __dirname + '/client.html'

app.listen 7076