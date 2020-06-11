// Query module
var Query = require('./query/query').Query,
		query = new Query();

// initial crawl
var numRequests = 66;
query.crawlCB(numRequests);
		
// Api module
var Api = require('./api/api').Api,
		api = new Api();

// fetch array of query.json from initial crawl
var data = query.fetchJSON();

// crawl api hrefs
api.goCrawl(data);

// consolidate query.json and api.json
var queryJSON = query.fetchJSON();
var apiJSON = api.fetchJSON();

for(var i = 0; i < queryJSON.length; i++) {
	queryJSON[i].api = apiJSON
}

