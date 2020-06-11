using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BusinessLogic.Interfaces;

namespace BusinessLogic
{
    //Класс, через который централизованно происходит обмен данными в приложении
    public class DataManager
    {
        private IUsersRepository usersRepository;
        private IFriendsRepository friendsRepository;
        private IFriendRequestsRepository friendRequestsRepository;
        private IMessagesRepository messagesRepository;
        private PrimaryMembershipProvider provider;

        public DataManager(IUsersRepository usersRepository, IFriendsRepository friendsRepository, IFriendRequestsRepository friendRequestsRepository, IMessagesRepository messagesRepository, PrimaryMembershipProvider provider)
        {
            this.usersRepository = usersRepository;
            this.friendsRepository = friendsRepository;
            this.friendRequestsRepository = friendRequestsRepository;
            this.messagesRepository = messagesRepository;
            this.provider = provider;
        }

        public IUsersRepository Users { get { return usersRepository; } }
        public IFriendsRepository Friends { get { return friendsRepository; } }
        public IFriendRequestsRepository FriendRequests { get { return friendRequestsRepository; } }
        public IMessagesRepository Messages { get { return messagesRepository; } }
        public PrimaryMembershipProvider MembershipProvider { get { return provider; } }
    }
}
