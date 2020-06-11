using BusinessLogic.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogic
{
    public class DataManager
    {
        private IUserRepository userRepository;
        private IFriendsRepository friendsRepository;
        private IFriendRequestsRepository friendsRequestRepository;
        private IMessagesRepository messagesRepository;
        private PrimaryMembershipProvider provider;

        public DataManager(IUserRepository userRepository, IFriendsRepository friendsRepository, IFriendRequestsRepository friendsRequestRepository, IMessagesRepository messagesRepository, PrimaryMembershipProvider provider)
        {
            this.userRepository = userRepository;
            this.friendsRepository = friendsRepository;
            this.friendsRequestRepository = friendsRequestRepository;
            this.messagesRepository = messagesRepository;
            this.provider = provider;
        }

        public IUserRepository Users { get { return userRepository; } }
        public IFriendsRepository Friends { get { return friendsRepository; } }
        public IFriendRequestsRepository FriendsRequests { get { return friendsRequestRepository; } }
        public IMessagesRepository Messages { get { return messagesRepository; } }
        public PrimaryMembershipProvider MembershipProvider { get { return provider; } }
    }
}
