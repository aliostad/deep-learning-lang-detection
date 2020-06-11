define(
    [
        "module/ngModule",
        "service/crudService",
        "service/jsonWebService"
    ],
    function (ngModule, CrudService) {

        ngModule.service("pageService",
            [
                "jsonWebService",
                "pageServiceUrl",

                function (jsonWebService, pageServiceUrl) {

                    var crudService = new CrudService(jsonWebService, pageServiceUrl);

                    return {
                        createPage: crudService.create,
                        retrievePage: crudService.retrieve,
                        updatePage: crudService.update,
                        removePage: crudService.remove
                    };
                }
            ]);
    });
