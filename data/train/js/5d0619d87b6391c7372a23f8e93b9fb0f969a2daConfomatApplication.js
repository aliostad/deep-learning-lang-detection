define(["sprd/model/Application", "js/core/Bindable"], function(Application, Bindable) {

    var ConfomatApplication = Bindable.inherit({
        defaults: {
            uploadMode: "privateMode",
            showProductTypeGallery: true,
            showProductGallery: true,
            showDesignGallery: true,
            showAddText: true,
            showDesignSearch: true,
            showDesignUpload: true,
            showMarketplaceDesigns: true,
            showPrices: true,
            showSaveAndShare: true,
            showSaveAndShareEmail: true
        }
    });

    return Application.inherit("sprd.model.application.ConfomatApplication", {
        defaults: {
            name: "confomat7",
            settings: ConfomatApplication
        },

        idField: "name"

    });
});