using System.Collections.Generic;
using SimpleInjectorSandbox.Models;
using SimpleInjectorSandbox.Repositories.Interfaces;

namespace SimpleInjectorSandbox.Repositories
{
    public class AuditTestRepository : ITestRepository
    {
        private readonly IAuditRepository<TestModel> _auditRepository;
        private readonly TestRepository _testRepository;

        public AuditTestRepository(IAuditRepository<TestModel> auditRepository, 
            TestRepository testRepository)
        {
            _auditRepository = auditRepository;
            _testRepository = testRepository;
        }

        public List<TestModel> GetAll()
        {
            var test = _testRepository.GetAll();
            test.AddRange(_auditRepository.Load());
            return test;
        }
    }
}