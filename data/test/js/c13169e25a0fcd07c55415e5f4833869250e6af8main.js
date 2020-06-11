var index = require('./index.js');
var api = require('./api.js');

app.get('/', index.index);
app.get('/api/create_consumer_key', api.create_consumer_key);
app.get('/api/:consumerKey/create_tag/:value', api.create_tag);
app.get('/api/:consumerKey/list_tag', api.list_tag);
app.get('/api/:consumerKey/list_twitts', api.list_twitts);
app.get('/api/:consumerKey/list_twitts_by_tag/:value', api.list_twitts_by_tag);

app.get('/api/:consumerKey/list_tag/:limit', api.list_tag);
app.get('/api/:consumerKey/list_twitts/:limit', api.list_twitts);
app.get('/api/:consumerKey/list_twitts_by_tag/:value/:limit', api.list_twitts_by_tag);