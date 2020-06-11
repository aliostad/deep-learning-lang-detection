
using SEP.HRMIS.IDal;
using SEP.HRMIS.Model;
using SEP.HRMIS.Model.DiyProcesss;
using SEP.HRMIS.SqlServerDal;

namespace SEP.HRMIS.Bll.DiyProcesses
{
    /// <summary>
    /// 
    /// </summary>
    public class UpdateDiyProcess : Transaction
    {
        private readonly IDiyProcessDal _IDiyProcessDal = new DiyProcessDal();

        private readonly DiyProcess _DiyProcess;

        /// <summary>
        /// 
        /// </summary>
        public UpdateDiyProcess(DiyProcess diyProcess)
        {
            _DiyProcess = diyProcess;
        }

        /// <summary>
        /// 
        /// </summary>
        public UpdateDiyProcess(DiyProcess diyProcess, IDiyProcessDal mockIDiyProcessDal)
        {
            _DiyProcess = diyProcess;
            _IDiyProcessDal = mockIDiyProcessDal;
        }

        protected override void Validation()
        {
            if (_IDiyProcessDal.CountDiyProcessByNameDiffPKID(_DiyProcess.ID, _DiyProcess.Name) > 0)
            {
                HrmisUtility.ThrowException(HrmisUtility._DiyProcess_Name_Repeat);
            }
        }

        protected override void ExcuteSelf()
        {
            try
            {
                _IDiyProcessDal.UpdateDiyProcess(_DiyProcess);

            }
            catch
            {
                BllUtility.ThrowException(BllExceptionConst._DbError);
            }
        }
    }
}
