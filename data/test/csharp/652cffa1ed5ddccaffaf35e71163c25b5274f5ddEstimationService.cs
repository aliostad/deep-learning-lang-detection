using System;
using System.Collections.Generic;
using System.Linq;
using Castle.Transactions;
using Shinetech.PointEstimation.Data;
using Shinetech.PointEstimation.Entities;
using Shinetech.PointEstimation.Services.Exceptions;

namespace Shinetech.PointEstimation.Services.Impl
{
    public class EstimationService : IEstimationService
    {
        private readonly IRepository<EstimationProcess> _processRepository;

        public EstimationService(IRepository<EstimationProcess> processRepository)
        {
            _processRepository = processRepository;
        }

        public EstimationProcess GetCurrentEstimationProcess() {
            return EstimationProcess.GetInstance();
        }

        [Transaction]
        public long StartNewEstimationProcess()
        {
            var currentEstimationProcess = GetCurrentEstimationProcess();
            if (currentEstimationProcess != null)
                return currentEstimationProcess.Id;

            var process = EstimationProcess.StartNew();
            _processRepository.Create(process);

            return process.Id;
        }

        [Transaction]
        public EstimationPoint Estimate(string voter, int point)
        {
            var currentEstimationProcess = GetCurrentEstimationProcess();
            if (currentEstimationProcess == null)
                throw new NotEstimationProcessRunningException();

            var estimationPoint = currentEstimationProcess.Estimate(voter, point);
            _processRepository.Update(currentEstimationProcess);

            return estimationPoint;
        }

        [Transaction]
        public long Finish()
        {
            var currentEstimationProcess = GetCurrentEstimationProcess();
            if (currentEstimationProcess == null)
                throw new NotEstimationProcessRunningException();

            currentEstimationProcess.Finish();
            _processRepository.Update(currentEstimationProcess);

            return currentEstimationProcess.Id;
        }

        [Transaction]
        public void Cancel()
        {
            var currentEstimationProcess = GetCurrentEstimationProcess();
            if (currentEstimationProcess == null)
                return;

            _processRepository.Delete(currentEstimationProcess);
        }

        public EstimationProcess GetEstimationProcess(long proccessId)
        {
            return _processRepository.Get(proccessId);
        }
    }
}