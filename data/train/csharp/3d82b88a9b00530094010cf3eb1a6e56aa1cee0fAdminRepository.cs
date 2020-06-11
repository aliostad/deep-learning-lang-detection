using Repository.RepositoryInterfaces;

namespace Repository.Repository
{
    public class AdminRepository : IAdminRepository
    {
        private readonly IAdminRepository m_AdminRepository;

        public AdminRepository(IAdminRepository adminRepository)
        {
            m_AdminRepository = adminRepository;
        }

        public int Authenticate(string userName, string password)
        {
            var adminId = m_AdminRepository.Authenticate(userName,password);

            return adminId;
        }
    }
}
