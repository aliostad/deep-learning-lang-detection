using System;
using SimpleUnity.Domain.Services.Interface;
using SimpleUnity.Repository;

namespace SimpleUnity.Domain.Services
{
    public class AdminServices : IAdminService
    {
        private readonly IBlobRepository _blobRepository;
        private readonly IBucketRepository _bucketRepository;
        private readonly IStorageAdminRepository _storageAdminRepository;

        //public AdminServices(IBucketRepository bucketRepository, IBlobRepository blobRepository, IStorageAdminRepository storageAdminRepository )
        //{
        //    _bucketRepository = bucketRepository;
        //    _blobRepository = blobRepository;
        //    _storageAdminRepository = storageAdminRepository;
        //}

        public AdminServices(IBucketRepository bucketRepository)
        {
            _bucketRepository = bucketRepository;
        }


        public void AddAccount()
        {
            _storageAdminRepository.AddAccount();
        }

        public void AddBlob()
        {
            _blobRepository.Add();
        }

        public void AddBucket()
        {
            _bucketRepository.Add();
        }
    }
}
