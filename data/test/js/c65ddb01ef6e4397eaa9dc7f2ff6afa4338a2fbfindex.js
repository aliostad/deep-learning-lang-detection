var usersController = require(__dirname + '/UsersController'),
	photosController = require(__dirname + '/PhotosController'),
	filesController = require(__dirname + '/FilesController'),
	categoriesController = require(__dirname + '/CategoriesController'),
    transactionsController = require(__dirname + '/TransactionsController');

    module.exports = {
    users: usersController,
    photos : photosController,
    categories : categoriesController,
    files: filesController,
    transactions : transactionsController
};