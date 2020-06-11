module.exports = function(app) {
    require('./ExpertApi')(app);
    require('./ExpertScheduleApi')(app);
    require('./ExpertScheduleRulesApi')(app);
    require('./IntegrationApi')(app);
    require('./IntegrationOwnerApi')(app);
    require('./PaymentApi')(app);
    require('./PayoutDetailApi')(app);
    require('./PhoneCallApi')(app);
    require('./PhoneNumberApi')(app);
    require('./SMSApi')(app);
    require('./TransactionApi')(app);
    require('./TwimlApi')(app);
    require('./UserApi')(app);
}