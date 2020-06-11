using IPM.Data.Infrastructure;
using IPM.Data.Repositories;
using IPM.Model.Models;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;

namespace IPM.Business
{
    public interface IInterviewProcessBusiness : IBusinessBase<InterviewProcess>
    {
        /// <summary>
        /// Get all interview process
        /// </summary>
        /// <returns>
        /// Success: list interview process
        /// Error: Exception
        /// </returns>
        IEnumerable<InterviewProcess> GetAll();
        /// <summary>
        /// Add interivew process
        /// </summary>
        /// <param name="process">interview process</param>
        /// <param name="listRound">list interview round in process</param>
        /// <returns>
        /// Success: interview process id
        /// Error: bad id (0) / exception
        /// </returns>
        int AddProcess(InterviewProcess process, List<RoundProcess> listRound);
        /// <summary>
        /// Get interview process by id include RoundProcess and InterviewRound
        /// </summary>
        /// <param name="id">process id</param>
        /// <returns>
        /// Success: Interview process
        /// Error: exception
        /// </returns>
        InterviewProcess GetProcessById(int id);
        /// <summary>
        /// Edit interview interview process
        /// </summary>
        /// <param name="process">interview process</param>
        /// <param name="listRound">list interview round in process</param>
        /// <returns>
        /// Success: Interview process
        /// Error: null / exception
        /// </returns>
        InterviewProcess Edit(InterviewProcess process, List<RoundProcess> listRound);
        /// <summary>
        /// Search interview process in multi field
        /// </summary>
        /// <param name="searchString">search string</param>
        /// <returns>
        /// Success: List search result
        /// Error: exception
        /// </returns>
        IEnumerable<InterviewProcess> Search(string searchString);
    }
    /// <summary>
    /// Interview process business
    /// </summary>
    public class InterviewProcessBusiness : BusinessBase<InterviewProcess>, IInterviewProcessBusiness
    {
        private IInterviewProcessRepository _interviewProcessRepository;
        private IRoundProcessRepository _roundProcessRepository;
        private IUnitOfWork _unitOfWork;
        /// <summary>
        /// bad object id.
        /// </summary>
        const int intBadId = 0;
        /// <summary>
        /// Interview process business contructor.
        /// </summary>
        /// <param name="interviewProcessRepository">interview process repository</param>
        /// <param name="roundProcessRepository">round process repository</param>
        /// <param name="unitOfWork">unit of work object</param>
        public InterviewProcessBusiness(IInterviewProcessRepository interviewProcessRepository, IRoundProcessRepository roundProcessRepository
            , IUnitOfWork unitOfWork)
            : base(interviewProcessRepository, unitOfWork)
        {
            this._interviewProcessRepository = interviewProcessRepository;
            this._roundProcessRepository = roundProcessRepository;
            this._unitOfWork = unitOfWork;
        }
        /// <summary>
        /// Get all interview process
        /// </summary>
        /// <returns>
        ///     Success: list interview process
        ///     Error: Exception
        /// </returns>
        public IEnumerable<InterviewProcess> GetAll()
        {
            log.Info("Function: GetAll");
            try
            {
                var listProcess = _interviewProcessRepository.Get(null, null, "Position");
                return listProcess;
            }
            catch (Exception exc)
            {
                throw new Exception(exc.Message);
            }
        }
        /// <summary>
        /// Add interivew process
        /// </summary>
        /// <param name="process">interview process</param>
        /// <param name="listRound">list interview round in process</param>
        /// <returns>
        ///     Success: interview process id
        ///     Error: bad id (0), exception
        /// </returns>
        public int AddProcess(InterviewProcess process, List<RoundProcess> listRound)
        {
            log.Info(String.Format("Function: AddProcess - process: {0} - listRound: {1}", process, listRound));
            //Add interview process
            InterviewProcess processAddResult = _interviewProcessRepository.Add(process);

            if (processAddResult == null)
            {
                log.Info(String.Format("Process: {0} - Message: Add interview process failed!", process));
                return intBadId;
            }
            else
            {
                //add interview round to process
                RoundProcess addRoundProcessResult = new RoundProcess();
                int roundOrder = 1;
                foreach (RoundProcess roundProcess in listRound)
                {
                    roundProcess.InterviewProcessID = processAddResult.ID;
                    roundProcess.RoundOrder = roundOrder;
                    addRoundProcessResult = _roundProcessRepository.Add(roundProcess);
                    if (addRoundProcessResult == null)
                    {
                        log.Info(String.Format("Process: {0} - ListRound: {1} - Message: Add interview process failed", process, listRound));
                        return intBadId;
                    }
                    roundOrder = roundOrder + 1;
                }
                //save work
                try
                {
                    Save();
                }
                catch (Exception exc)
                {
                    throw new Exception(exc.Message);
                }
                return processAddResult.ID;
            }
        }
        /// <summary>
        /// Get interview process by id include RoundProcess and InterviewRound
        /// </summary>
        /// <param name="id">process id</param>
        /// <returns>
        ///     Success: Interview process
        ///     Error: exception
        /// </returns>
        public InterviewProcess GetProcessById(int id)
        {
            log.Info(String.Format("Function: GetProcessById - id: {0}", id));
            try
            {
                return _interviewProcessRepository.GetProcessById(id);
            }
            catch (Exception exc)
            {
                throw new Exception(exc.Message);
            }
        }
        /// <summary>
        /// Edit interview interview process
        /// </summary>
        /// <param name="process">interview process</param>
        /// <param name="listRound">list interview round in process</param>
        /// <returns>
        /// Success: Interview process
        /// Error: null / exception
        /// </returns>
        public InterviewProcess Edit(InterviewProcess process, List<RoundProcess> listRound)
        {
            log.Info(String.Format("Function: Edit - process: {0} - listRound: {1}", process, listRound));
            //update interview process
            InterviewProcess updateProcessResult = _interviewProcessRepository.Update(process);
            if (updateProcessResult == null)
            {
                log.Info(String.Format("Process: {0} - Message: Update interview process failed", process));
            }
            else
            {
                //set round order
                int roundOrder = 1;
                for (int roundIndex = 0; roundIndex < listRound.Count; roundIndex++)
                {
                    listRound[roundIndex].RoundOrder = roundIndex + 1;
                }

                //find roundProcess that do not in process anymore, then delete it
                List<RoundProcess> listRoundProcess = _roundProcessRepository.GetByProcessId(process.ID).ToList();
                RoundProcess roundProcessFindResult = new RoundProcess();

                foreach (RoundProcess roundProcess in listRoundProcess.ToList())
                {
                    roundProcessFindResult = listRound.FirstOrDefault(r => r.InterviewRoundID == roundProcess.InterviewRoundID);
                    if (roundProcessFindResult == null)
                    {
                        //relationship not exist in listRound, remove it from database
                        _roundProcessRepository.Delete(roundProcess);
                    }
                    else
                    {
                        //if relationship is exist in list, edit RoundOrder of it and remove it from list round to do not be duplicate when save list
                        roundProcess.RoundOrder = roundProcessFindResult.RoundOrder;
                        _roundProcessRepository.Update(roundProcess);
                        listRound.Remove(roundProcessFindResult);
                    }
                }
                //add relationship between round and process
                foreach (RoundProcess round in listRound)
                {
                    _roundProcessRepository.Add(round);
                }

                try
                {
                    Save();
                }
                catch (Exception exc)
                {
                    throw new Exception(exc.Message);
                }
            }
            return updateProcessResult;
        }
        /// <summary>
        /// Search interview process in multi field
        /// </summary>
        /// <param name="searchString">search string</param>
        /// <returns>
        /// Success: List search result
        /// Error: exception
        /// </returns>
        public IEnumerable<InterviewProcess> Search(string searchString)
        {
            log.Info(String.Format("Function: Search - process: {0}", searchString));
            try
            {
                //add filter search
                IEnumerable<InterviewProcess> listInterviewProcess = _interviewProcessRepository.Get(null, null, "Position");

                listInterviewProcess = listInterviewProcess
                    .Where(p => p.ProcessName.ToUpper().Contains(searchString.ToUpper())
                    || p.Position.Name.ToUpper().Contains(searchString.ToUpper())
                    || p.StartDate.ToString("dd/MM/yyyy").Contains(searchString));

                return listInterviewProcess;
            }
            catch (Exception exc)
            {
                throw new Exception(exc.Message);
            }
        }
    }
}
