define(
    [
        "module/ngModule",
        "types/enums",
        "service/crudService",
        "service/jsonWebService"
    ],
    function (ngModule, enums, CrudService) {

        ngModule.service("noteService",
            [
                "jsonWebService",
                "noteServiceUrl",
                "notesByPageServiceUrl",

                function (jsonWebService, noteServiceUrl, notesByPageServiceUrl) {

                    var crudService = new CrudService(jsonWebService, noteServiceUrl);

                    function getNotesByPage(pageId, successCallback, failureCallback) {

                        var serviceUrlWithParams = notesByPageServiceUrl.replace("{pageId}", pageId);
                        jsonWebService.execute(serviceUrlWithParams, enums.HttpMethod.GET, null, successCallback,
                            failureCallback,
                            true);
                    }
                    return {
                        getNotesByPage: getNotesByPage,
                        create: crudService.create,
                        retrieve: crudService.retrieve,
                        update: crudService.update,
                        remove: crudService.remove
                    };
                }
            ])
    });
