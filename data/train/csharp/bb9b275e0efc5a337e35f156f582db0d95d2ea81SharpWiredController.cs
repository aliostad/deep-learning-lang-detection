using SharpWired.Model;

namespace SharpWired.Controller {
    public class SharpWiredController {
        private ChatController chatController;
        private UserController userController;
        private NewsController newsController;
        private FileListingController fileListingController;
        private FileTransferController fileTransferController;
        private GroupController groupController;
        private PrivateMessageController privateMessagesController;
        private readonly SharpWiredModel model;
        private Server Server { get; set; }
        private static SharpWiredController instance;

        public static SharpWiredController Instance {
            get { return instance; }
            set {
                if (instance == null) {
                    instance = value;
                } else {
                    throw new SingletonException("Singleton already created");
                }
            }
        }

        public FileTransferController FileTransferController { get { return fileTransferController; } }
        public FileListingController FileListingController { get { return fileListingController; } }
        public ChatController ChatController { get { return chatController; } }
        public UserController UserController { get { return userController; } }

        public SharpWiredController(SharpWiredModel model) {
            this.model = model;
            this.model.Connected += OnConnected;
        }

        private void OnConnected(Server server) {
            Server = server;
            Server.Online += OnOnline;
        }

        private void OnOnline() {
            Server.Offline += OnOffline;

            chatController = new ChatController(model);
            userController = new UserController(model);
            groupController = new GroupController(model);
            newsController = new NewsController(model);
            fileListingController = new FileListingController(model);
            fileTransferController = new FileTransferController(model);
            privateMessagesController = new PrivateMessageController(model);
        }

        private void OnOffline() {
            chatController = null;
            userController = null;
            groupController = null;
            newsController = null;
            fileListingController = null;
            fileTransferController = null;
            privateMessagesController = null;
        }
    }
}