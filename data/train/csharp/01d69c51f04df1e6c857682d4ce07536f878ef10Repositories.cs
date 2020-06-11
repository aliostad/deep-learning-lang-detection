namespace BlogsApp.DataAccess.Repositories
{
    public class Repositories : IRepositories
    {
        public Repositories(string connectionString)
        {
            MigrationRepository = new MigrationRepository(connectionString);
            UserRepository = new UserRepository(connectionString);
            UserRoleRepository = new UserRoleRepository(connectionString);
            UserRoleUserRepository = new UserRoleUserRepository(connectionString);
            PostRepository = new PostRepository(connectionString);
            CommentRepository = new CommentRepository(connectionString);
        }

        public MigrationRepository MigrationRepository { get; }
        public UserRepository UserRepository { get; }
        public UserRoleRepository UserRoleRepository { get; }
        public UserRoleUserRepository UserRoleUserRepository { get; }
        public PostRepository PostRepository { get; }
        public CommentRepository CommentRepository { get; }
    }
}
