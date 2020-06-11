FactorySim.module("FactoryApp.Show", function(Show, App, Backbone, Marionette, $, _){

    Show.Controller = App.Controllers.Base.extend({
        initialize: function (options) {
            this.factory = options.factory;
            this.layout =  this.getLayout();

            this.listenTo(this.layout, "show", function () {
                this.showWorkers();
                this.showResources();
                this.showJobs();
                this.showMarkets();
                this.showConnections();
            });

            this.show(this.layout);
        },


        showWorkers: function () {
            App.execute("show:workers", {
                region: this.layout.workersRegion,
                workers: this.factory.workers
            });
        },

        showResources: function() {
            App.execute("show:resources", {
                region: this.layout.resourcesRegion,
                resources: this.factory.resources
            });
        },

        showJobs: function() {
            App.execute("show:jobs", {
                region: this.layout.jobsRegion,
                jobs: this.factory.jobs
            });
        },

        showMarkets: function() {
            App.execute("show:markets", {
                region: this.layout.marketsRegion,
                markets: this.factory.markets
            });
        },

        showConnections: function () {
            _.defer(function() {App.vent.trigger("render:connections");});
        },

        getLayout: function () {
            return new Show.Layout();
        }


    });

});