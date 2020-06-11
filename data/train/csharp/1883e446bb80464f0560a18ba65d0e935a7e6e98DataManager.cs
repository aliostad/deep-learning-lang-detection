using BusinessLogic.Interfaces;

namespace BusinessLogic
{
    public class DataManager
    {
        private IUsersRepository usersRepository;
        private IFriendsRepository friendsRepository;
        private IFriendRequestsRepository friendRequestsRepository;
        private IMessagesRepository messagesRepository;
        private IPicturesRepository picturesRepository;
        private PrimaryMembershipProvider provider;

        public DataManager(IUsersRepository usersRepository, IFriendsRepository friendsRepository, IFriendRequestsRepository friendRequestsRepository, IMessagesRepository messagesRepository, IPicturesRepository picturesRepository, PrimaryMembershipProvider provider)
        {
            this.usersRepository = usersRepository;
            this.friendsRepository = friendsRepository;
            this.friendRequestsRepository = friendRequestsRepository;
            this.messagesRepository = messagesRepository;
            this.picturesRepository = picturesRepository;
            this.provider = provider;
        }

        public IUsersRepository Users { get { return usersRepository; } }
        public IFriendsRepository Friends { get { return friendsRepository; } }
        public IFriendRequestsRepository FriendRequests { get { return friendRequestsRepository; } }
        public IMessagesRepository Messages { get { return messagesRepository; } }
        public IPicturesRepository Pictures { get { return picturesRepository; } }
        public PrimaryMembershipProvider MembershipProvider { get { return provider; } }
    }
}
