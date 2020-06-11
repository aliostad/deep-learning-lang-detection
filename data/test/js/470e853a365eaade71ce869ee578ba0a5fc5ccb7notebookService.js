define(
    [
        "module/ngModule",
        "types/enums",
        "service/crudService",
        "service/jsonWebService"
    ],
    function (ngModule, enums, CrudService) {

        ngModule.service("notebookService",
            [
                "jsonWebService",
                "notesPagesServiceUrl",
                "notebookServiceUrl",

                function (jsonWebService, notesPagesServiceUrl, notebookServiceUrl) {

                    var crudService = new CrudService(jsonWebService, notebookServiceUrl);

                    function getNotebooksAndPages(successCallback, failureCallback) {

                        jsonWebService.execute(notesPagesServiceUrl, enums.HttpMethod.GET, null, successCallback,
                            failureCallback, true);
                    }

                    return {
                        getNotebooksAndPages: getNotebooksAndPages,
                        createNotebook: crudService.create,
                        retrieveNotebook: crudService.retrieve,
                        updateNotebook: crudService.update,
                        removeNotebook: crudService.remove
                    };
                }
            ]);
    });
