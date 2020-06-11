using System.Collections.Generic;
using System.Linq;
using ScripturePublishingEntity.Entities;
using ScripturePublishingEntity.Repositories;

namespace ScripturePublishingService.Services
{
    public class ProcessStepService : IProcessStepService
    {
        private readonly IProcessStepRepository _processStepRepository;

        public ProcessStepService(IProcessStepRepository processStepRepository)
        {
            _processStepRepository = processStepRepository;
        }

        public ProcessStep GetProcessStepById(int id)
        {
            return _processStepRepository.GetById(id);
        }

        public List<ProcessStep> GetProcessSteps()
        {
            return _processStepRepository.Get().ToList();
        }

        public ProcessStep Create(string actionTypeId, string processId)
        {
            var processStep = new ProcessStep
            {
                ActionTypeID = int.Parse(actionTypeId),
                ProcessID = int.Parse(processId)
            };

            return _processStepRepository.Add(processStep);
        }

        public ProcessStep Update(ProcessStep processStep)
        {
            return _processStepRepository.Update(processStep);
        }

        public void Delete(ProcessStep processStep)
        {
            _processStepRepository.Delete(processStep);
        }
    }
}