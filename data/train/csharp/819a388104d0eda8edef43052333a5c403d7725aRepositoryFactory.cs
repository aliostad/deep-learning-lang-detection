namespace Training.Workshop.Data.FileSystem
{
    public class RepositoryFactory : IRepositoryFactory
    {
        /// <summary>
        /// Gets user repository
        /// </summary>
        /// <returns></returns>
        public IUserRepository GetUserRepository()
        {
            return new UserRepository();
        }
        /// <summary>
        /// Gets bike repository
        /// </summary>
        /// <returns></returns>
        public IBikeRepository GetBikeRepository()
        {
            return new BikeRepository();
        }
        /// <summary>
        /// Gets Sparepart repository
        /// </summary>
        /// <returns></returns>
        public ISparepartRepository GetSparepartRepository()
        {
            return new SparepartRepository();
        }
    }
}
