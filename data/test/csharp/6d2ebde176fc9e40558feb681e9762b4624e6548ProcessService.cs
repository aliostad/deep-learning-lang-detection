using System.Collections.Generic;
using System.Linq;
using ScripturePublishingEntity.Entities;
using ScripturePublishingEntity.Repositories;

namespace ScripturePublishingService.Services
{
    public class ProcessService : IProcessService
    {
        private readonly IProcessRepository _processRepository;

        public ProcessService(IProcessRepository processRepository)
        {
            _processRepository = processRepository;
        }

        public Process GetProcessById(int id)
        {
            return _processRepository.GetById(id);
        }

        public List<Process> GetProcesses()
        {
            return _processRepository.Get().ToList();
        }

        public Process Create(string name, int version)
        {
            var process = new Process {
                Name = name,
                Version = version
            };

            return _processRepository.Add(process);
        }

        public Process Update(Process process)
        {
            return _processRepository.Update(process);
        }

        public void Delete(Process process)
        {
            _processRepository.Delete(process);
        }
    }
}