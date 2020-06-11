define([
	"views/ApplicationView",
	"controllers/ApplicationController",

        "views/CoffeeView",
        "controllers/CoffeeController",

        "views/ActionsView",
        "controllers/ActionsController",

        "views/ProgressBarView",
        "controllers/ProgressBarController",

        "views/RepoView",
        "controllers/RepoController",

        "views/SchedulesView",
        "controllers/SchedulesController",
        "controllers/ScheduleController",

        "views/TwitterView",
        "controllers/TwitterController",

        "views/PhotosView",
        "controllers/PhotosController",

        "views/GoodPointsView",
        "controllers/GoodPointsController",

        "controllers/TimeController",
	"app/router"
], function(
        ApplicationView, ApplicationController,
        CoffeeView, CoffeeController,

        ActionsView, ActionsController,

        ProgressBarView, ProgressBarController,

        RepoView, RepoController,

        SchedulesView, SchedulesController, ScheduleController,

        TwitterView, TwitterController,

        PhotosView, PhotosController,

        GoodPointsView, GoodPointsController,

        TimeController,
        Router){

        /*Module Pattern*/
	var App = {
		ApplicationView: ApplicationView,
		ApplicationController: ApplicationController,

                CoffeeView: CoffeeView,
                CoffeeController: CoffeeController,

                ActionsView: ActionsView,
                ActionsController: ActionsController,

                ProgressBarView: ProgressBarView,
                ProgressBarController: ProgressBarController,

                RepoView: RepoView,
                RepoController: RepoController,

                SchedulesView: SchedulesView,
                SchedulesController: SchedulesController,
                ScheduleController: ScheduleController,

                TwitterView: TwitterView,
                TwitterController: TwitterController,

                PhotosView: PhotosView,
                PhotosController: PhotosController,

                GoodPointsView: GoodPointsView,
                GoodPointsController: GoodPointsController,

                TimeController: TimeController,
		Router: Router
	};

	return App;
});
