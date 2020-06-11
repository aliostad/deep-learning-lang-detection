var express = require('express'),
 bodyParser = require('body-parser'),
        api = require('./api/api');

var app = express();

app.configure('development', function () {
  app.use(express.logger('dev'));
  app.locals.pretty = true;
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(express.static(__dirname + '/dist'));

// Home
app.get('/api/home/:id', api.home.home);
app.get('/api/home', api.home.homes);
app.post('/api/home/:id', api.home.updateHome);
app.delete('/api/home/:id', api.home.deleteHome);
app.post('/api/home', api.home.newHome);

// News
app.get('/api/news/:id', api.news.news);
app.get('/api/news', api.news.newss);
app.post('/api/news/:id', api.news.updateNews);
app.delete('/api/news/:id', api.news.deleteNews);
app.post('/api/news', api.news.newNews);

// Facilities
app.get('/api/facilities/:id', api.facilities.facilities);
app.get('/api/facilities', api.facilities.facilitiess);
app.post('/api/facilities/:id', api.facilities.updateFacilities);
app.delete('/api/facilities/:id', api.facilities.deleteFacilities);
app.post('/api/facilities', api.facilities.newFacilities);

// Research
app.get('/api/research/:id', api.research.research);
app.get('/api/research', api.research.researchs);
app.post('/api/research/:id', api.research.updateResearch);
app.delete('/api/research/:id', api.research.deleteResearch);
app.post('/api/research', api.research.newResearch);

// People
app.get('/api/people/:id', api.people.people);
app.get('/api/people', api.people.peoples);
app.post('/api/people/:id', api.people.updatePeople);
app.delete('/api/people/:id', api.people.deletePeople);
app.post('/api/people', api.people.newPeople);

// Funding
app.get('/api/funding/:id', api.funding.funding);
app.get('/api/funding', api.funding.fundings);
app.post('/api/funding/:id', api.funding.updateFunding);
app.delete('/api/funding/:id', api.funding.deleteFunding);
app.post('/api/funding', api.funding.newFunding);

// Education
app.get('/api/education/:id', api.education.education);
app.get('/api/education', api.education.educations);
app.post('/api/education/:id', api.education.updateEducation);
app.delete('/api/education/:id', api.education.deleteEducation);
app.post('/api/education', api.education.newEducation);

// Datasets
app.get('/api/datasets/:id', api.datasets.datasets);
app.get('/api/datasets', api.datasets.datasetss);
app.post('/api/datasets/:id', api.datasets.updateDatasets);
app.delete('/api/datasets/:id', api.datasets.deleteDatasets);
app.post('/api/datasets', api.datasets.newDatasets);

// Lecture
app.get('/api/lecture/:id', api.lecture.lecture);
app.get('/api/lecture', api.lecture.lectures);
app.post('/api/lecture/:id', api.lecture.updateLecture);
app.delete('/api/lecture/:id', api.lecture.deleteLecture);
app.post('/api/lecture', api.lecture.newLecture);

// Industry
app.get('/api/industry/:id', api.industry.industry);
app.get('/api/industry', api.industry.industrys);
app.post('/api/industry/:id', api.industry.updateIndustry);
app.delete('/api/industry/:id', api.industry.deleteIndustry);
app.post('/api/industry', api.industry.newIndustry);

// Jobs
app.get('/api/jobs/:id', api.jobs.jobs);
app.get('/api/jobs', api.jobs.jobss);
app.post('/api/jobs/:id', api.jobs.updateJobs);
app.delete('/api/jobs/:id', api.jobs.deleteJobs);
app.post('/api/jobs', api.jobs.newJobs);

// Links
app.get('/api/links/:id', api.links.links);
app.get('/api/links', api.links.linkss);
app.post('/api/links/:id', api.links.updateLinks);
app.delete('/api/links/:id', api.links.deleteLinks);
app.post('/api/links', api.links.newLinks);

app.get('/sniff', function(req,res) {
  res.send();
});

app.get('/api/export', api.exportCollections);

app.get('/', function(req, res) {
  res.sendfile('dist/index.html');
});

/* Start Server */
app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", this.address().port, app.settings.env);
});
