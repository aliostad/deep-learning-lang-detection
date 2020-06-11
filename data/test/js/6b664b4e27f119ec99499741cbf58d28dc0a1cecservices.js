var folder = require('./pb/dt/apigw/v1/folder_grpc_pb.js'),
    label = require('./pb/dt/apigw/v1/label_grpc_pb.js'),
    thing = require('./pb/dt/apigw/v1/thing_grpc_pb.js'),
    note = require('./pb/dt/apigw/v1/note_grpc_pb.js'),
    navigation = require('./pb/dt/apigw/v1/navigation_grpc_pb.js'),
    notification = require('./pb/dt/apigw/v1/notification_grpc_pb.js');

// Export service definitions
exports.FolderServiceService = folder.FolderServiceService;
exports.LabelServiceService = label.LabelServiceService;
exports.ThingServiceService = thing.ThingServiceService;
exports.NoteServiceService = note.NoteServiceService;
exports.NavigationServiceService = note.NavigationServiceService;
exports.NotificationServiceService = notification.NotificationServiceService;

// Export service clients
exports.FolderServiceClient = folder.FolderServiceClient;
exports.LabelServiceClient = label.LabelServiceClient;
exports.ThingServiceClient = thing.ThingServiceClient;
exports.NoteServiceClient = note.NoteServiceClient;
exports.NavigationServiceClient = note.NavigationServiceClient;
exports.NotificationServiceClient = notification.NotificationServiceClient;
