/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');

function logger(req,res,next){
  console.log(new Date(), req.method, req.url);
  next();
}

module.exports = function(app) {

  //log everything for now
  app.use(logger);

  // Insert routes below
  app.use('/api/patient', require('./api/patient'));
  app.use('/api/totalRiskByVAMCPieChart', require('./api/totalRiskByVAMCPieChart'));
  app.use('/api/getListOfVAMC', require('./api/getListOfVAMC'));
  app.use('/api/clinicalDecisionSupport', require('./api/clinicalDecisionSupport'));
  app.use('/api/suicideData', require('./api/suicideData'));
  app.use('/api/topMidRiskMetrics', require('./api/topMidRiskMetrics'));
  app.use('/api/genderDistributionMetrics', require('./api/genderDistributionMetrics'));
  app.use('/api/ageGroupsMetrics', require('./api/ageGroupsMetrics'));
  app.use('/api/militaryBranchMetrics', require('./api/militaryBranchMetrics'));
  app.use('/api/VAMCMetrics', require('./api/VAMCMetrics'))
  app.use('/api/outReachStatusMetrics', require('./api/outReachStatusMetrics'));
  app.use('/api/prediction', require('./api/prediction'));
  app.use('/api/enterdata', require('./api/enterdata')); 
  app.use('/api/patientContact', require('./api/patientContact'));
  app.use('/api/emergencyContact', require('./api/emergencyContact'));
  app.use('/api/patientFlagData', require('./api/patientFlagData'));
  app.use('/api/medicationData', require('./api/medicationData'));
  app.use('/api/diagnosesData', require('./api/diagnosesData'));
  app.use('/api/appointmentData', require('./api/appointmentData'));
  app.use('/api/visnRoster', require('./api/visnRoster'));
  app.use('/api/facilityRoster', require('./api/facilityRoster'));
  app.use('/api/audit', require('./api/audit'));
  app.use('/api/communityResource', require('./api/communityResource'));
  app.use('/api/CDSQuestionnaire', require('./api/CDSQuestionnaire'));

  app.use('/api/dashboard', require('./api/dashboard'));

  app.use('/auth', require('./auth'));
  app.use('/api/user', require('./api/user'));
  app.use('/encryption', require('./encryption'));

  app.route('/login')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + 'index.html');
  });

  app.route('/*')
    .get(function(req, res) {
      res.send('NOT FOUND',404);
  });
};
