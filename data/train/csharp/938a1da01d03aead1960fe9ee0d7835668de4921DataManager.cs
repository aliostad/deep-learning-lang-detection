using BusinessLogic.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusinessLogic
{
    //Класс, через который централизованно происходит обмен данными в приложении
  public  class DataManager
    {
        private IUserRepository usersRepository;
        private IFriendsRepository friendsRepository;
        private IFriendRequestsRepository friendRequestsRepository;
        private IMessagesRepository messagesRepository;
        private IPictureRepository pictureRepository;
        private IMusicRepository musicRepository;
      
        private PrimaryMembershipProvider provider;

        public DataManager(IUserRepository usersRepository, IFriendsRepository friendsRepository, IFriendRequestsRepository friendRequestsRepository, 
            IMessagesRepository messagesRepository, IPictureRepository pictureRepository,IMusicRepository musicRepository,IPostRepository postRepository,
            ICommentRepository commentReposiyory, PrimaryMembershipProvider provider)
        {
            this.usersRepository = usersRepository;
            this.friendsRepository = friendsRepository;
            this.friendRequestsRepository = friendRequestsRepository;
            this.messagesRepository = messagesRepository;
            this.pictureRepository = pictureRepository;
            this.musicRepository = musicRepository;
                      
            this.provider = provider;
        }

        public IUserRepository Users { get { return usersRepository; } }
        public IFriendsRepository Friends { get { return friendsRepository; } }
        public IFriendRequestsRepository FriendRequests { get { return friendRequestsRepository; } }
        public IMessagesRepository Messages { get { return messagesRepository; } }
        public IPictureRepository Pictures { get { return pictureRepository; } }
        public IMusicRepository Musics { get { return musicRepository; } }
        public PrimaryMembershipProvider MembershipProvider { get { return provider; } }
    }
}
