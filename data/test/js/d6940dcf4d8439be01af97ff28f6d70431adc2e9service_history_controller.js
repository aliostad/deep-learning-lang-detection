function ServiceHistoryController($log, $state, $scope, serviceBranches, serviceRankTypes, serviceRanks, serviceAwards){
    var model = this;
    $log.debug("ServiceHistoryController::Begin");

    model.contactType = $state.params.contactType;

    model.promises = [serviceBranches.$promise, serviceRankTypes.$promise, serviceRanks.$promise, serviceAwards.$promise];

    model.branches = serviceBranches; // [] || {}
    model.rankTypes = serviceRankTypes;
    model.ranks = serviceRanks;
    model.awards = serviceAwards;

    model.goTo = function() {
        // Create or update service histories
        $state.transitionTo('applications.serviceAwards', {contactType: model.contactType});
    };

    $log.debug("ServiceHistoryController::End");
}
angular.module('hf').controller('ServiceHistoryController', ServiceHistoryController);
