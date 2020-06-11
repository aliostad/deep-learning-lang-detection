define([
	'app',

	'app/controllers/pages/projects_controller',
	'app/controllers/pages/project_details_controller',

	'app/controllers/dialogs/component_settings_controller',
	'app/controllers/dialogs/create_project_controller',
	'app/controllers/dialogs/create_page_controller',
	'app/controllers/dialogs/create_predefined_data_source_controller',

	'app/controllers/components/component_controller',
	'app/controllers/components/lists/grid_view_controller'
], function(app, ProjectsController, ProjectDetailsController,
		ComponentSettingsController, CreateProjectController,
		CreatePageController, CreateDataSourceController, ComponentController,
		GridViewController) {
	'use strict';

	app.
		controller('ProjectsController', ProjectsController).
		controller('ProjectDetailsController', ProjectDetailsController).

		controller('ComponentSettingsController', ComponentSettingsController).
		controller('CreateProjectController', CreateProjectController).
		controller('CreatePageController', CreatePageController).
		controller('CreateDataSourceController', CreateDataSourceController).

		controller('ComponentController', ComponentController).
		controller('GridViewController', GridViewController);
});