var fs = require('fs');

var apiDocs = fs.readFileSync('./api.tmp', 'utf8');

apiDocs = apiDocs.replace(RegExp('[\']?,\\s?function\\(\\) \\{', 'g'), '');
apiDocs = apiDocs.replace(RegExp('describe[\\(]+[\']+([#:@.]+)', 'gm'), '$1 ');
apiDocs = apiDocs.replace(RegExp('describe[\\(]+[\']+([!]+).+$', 'gm'), '');
apiDocs = apiDocs.replace(RegExp('^describe[\\(]+[\']+(.+)', 'gm'), '\n\n## $1\n');
apiDocs = apiDocs.replace(RegExp('describe[\\(]+[\']+\\s{1,2}', 'gm'), '');
apiDocs = apiDocs.replace(RegExp('[\\t]{2,3}', 'gm'), '\t');

fs.writeFileSync('API.md', apiDocs, 'utf8');
