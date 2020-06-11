define([
    'Console',
    'Underscore',
    'services/rest/LoginService',
    'services/rest/UserService',
    'services/rest/SchemaService',
    'services/rest/ImService',
    'services/rest/LobbyService',
    'services/rest/StationService',
    'services/rest/LineService',
    'services/rest/ImStatusService',
    'services/rest/MediaService',
    'services/rest/MediaContentService',
    'services/rest/BuildInfoService',
    'services/rest/ImStatisticService',
    'services/client/ImTestService',
    'services/client/NewsService',
    'services/client/UploadService',
    'services/client/ValidationErrorProcessorService',
    'services/rest/MessageService',
    'services/rest/MessageListService',
    'services/rest/PassengerMessageService'
], function (Console, _, LoginService, UserService, SchemaService, ImService, LobbyService, StationService, LineService, ImStatusService, MediaService, MediaContentService, BuildInfoService, ImStatisticService, ImTestService, NewsService, UploadService, ValidationErrorProcessorService, MessageService, MessageListService, PassengerMessageService) {
    "use strict";

    var restServices = {
        LoginService: LoginService,
        UserService: UserService,
        SchemaService: SchemaService,
        ImService: ImService,
        LobbyService: LobbyService,
        StationService: StationService,
        LineService: LineService,
        ImStatusService: ImStatusService,
        MediaService: MediaService,
        MediaContentService: MediaContentService,
        BuildInfoService: BuildInfoService,
        MessageService: MessageService,
        MessageListService: MessageListService,
        PassengerMessageService: PassengerMessageService,
        ImStatisticService: ImStatisticService
    };

    var clientServices = {
        NewsService: NewsService,
        ImTestService: ImTestService,
        UploadService: UploadService,
        ValidationErrorProcessorService: ValidationErrorProcessorService
    };

    return {
        initialize: function (module) {
            _.each(restServices, function (service, name) {
                module.factory(name, service)
            });
            _.each(clientServices, function (service, name) {
                module.service(name, service)
            });
        }
    }
});