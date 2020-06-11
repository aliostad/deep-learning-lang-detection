namespace BlogsApp.DataAccess.Repositories
{
    public interface IRepositories
    {
        /// <summary>
        /// Migration repository
        /// </summary>
        MigrationRepository MigrationRepository { get; }

        /// <summary>
        /// User repository
        /// </summary>
        UserRepository UserRepository { get; }

        /// <summary>
        /// User role repository
        /// </summary>
        UserRoleRepository UserRoleRepository { get; }

        /// <summary>
        /// User role user repository
        /// </summary>
        UserRoleUserRepository UserRoleUserRepository { get; }

        /// <summary>
        /// Post repository
        /// </summary>
        PostRepository PostRepository { get; }

        /// <summary>
        /// Comment repository
        /// </summary>
        CommentRepository CommentRepository { get; }
    }
}
