var DataService = require("montage-data/logic/service/data-service").DataService,
	IssueService = require("logic/issue-service").IssueService,
	ProjectService = require("logic/project-service").ProjectService;



/**
 * Provides issue data.
 *
 * @class
 * @extends external:DataService
 */
exports.JiraService = DataService.specialize(/** @lends JiraService.prototype */{

    constructor: {
        value: function () { 
        	DataService.call(this);
         	this.addChildService(new IssueService());

        }
    }

});