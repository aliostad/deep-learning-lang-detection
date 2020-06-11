const dependencies = [
  'ngResource',
  'app.constants'
]

angular.module('api-services', dependencies)

require('./authorizations-api.service.coffee')
require('./quote-approval-api.service.coffee')
require('./copilot-project-details-api.service.coffee')
require('./copilot-projects-api.service.coffee')
require('./copilot-unclaimed-projects-api.service.coffee')
require('./inboxes-api.service.coffee')
require('./inboxes-project-api.service.coffee')
require('./message-update-api.service.coffee')
require('./messages-api.service.coffee')
require('./profiles-api.service.coffee')
require('./project-estimates-api.service.coffee')
require('./projects-api.service.coffee')
require('./status-report-api.service.coffee')
require('./status-report-collection-api.service.coffee')
require('./status-report-detail-api.service.coffee')
require('./steps-api.service.coffee')
require('./submissions-api.service.coffee')
require('./submissions-messages-api.service.coffee')
require('./submit-work-api.service.coffee')
require('./threads-api.service.coffee')
require('./timeline-api.service.coffee')
require('./upsell-api.service.coffee')
require('./user-v3-api.service.coffee')
require('./work-api.service.coffee')
require('./launch-project-api.service.coffee')

