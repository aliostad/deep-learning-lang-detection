var CustomerController = require('./CustomerController')
var FeedController = require('./FeedController')
var GroupController = require('./GroupController')
var MessageController = require('./MessageController')
var ProviderController = require('./ProviderController')
var ScheduleController = require('./ScheduleController')
var TransactionController = require('./TransactionController')
var UserController = require('./UserController')

module.exports = {
	
	customer: CustomerController,
	feed: FeedController,
	group: GroupController,
	message: MessageController,
	provider: ProviderController,
	schedule: ScheduleController,
	transaction: TransactionController,
	user: UserController,
}