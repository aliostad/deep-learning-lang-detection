using SocialMedia.Models;

namespace SocialMedia.DAL
{
    public class UnitOfWork
    {
        private ApplicationDbContext context = new ApplicationDbContext();
        private UserMessagesRepository messagesRepository;
        private DialogsRepository dialogsRepository;
        private UserWallPostsRepository usersWallPostsRepository;
        private FriendsRepository friendsRepository;
        private UsersRepository usersRepository;

        public UserMessagesRepository UserMessages
        {
            get
            {
                if (messagesRepository == null)
                    messagesRepository = new UserMessagesRepository(context);
                return messagesRepository;
            }
        }

        public DialogsRepository Dialogs
        {
            get
            {
                if (dialogsRepository == null)
                    dialogsRepository = new DialogsRepository(context);
                return dialogsRepository;
            }
        }

        public UserWallPostsRepository UserWallPosts
        {
            get
            {
                if (usersWallPostsRepository == null)
                    usersWallPostsRepository = new UserWallPostsRepository(context);
                return usersWallPostsRepository;
            }
        }

        public FriendsRepository Friends
        {
            get
            {
                if (friendsRepository == null)
                    friendsRepository = new FriendsRepository(context);
                return friendsRepository;
            }
        }

        public UsersRepository Users
        {
            get
            {
                if (usersRepository == null)
                    usersRepository = new UsersRepository(context);
                return usersRepository;
            }
        }

        public void Save()
        {
            context.SaveChanges();
        }

    }
}