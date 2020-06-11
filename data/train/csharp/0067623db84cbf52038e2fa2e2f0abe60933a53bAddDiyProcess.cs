
using SEP.HRMIS.IDal;
using SEP.HRMIS.Model;
using SEP.HRMIS.Model.DiyProcesss;
using SEP.HRMIS.SqlServerDal;

namespace SEP.HRMIS.Bll.DiyProcesses
{
    /// <summary>
    /// 
    /// </summary>
    public class AddDiyProcess : Transaction
    {
        private readonly IDiyProcessDal _IDiyProcessDal = new DiyProcessDal();

        private readonly DiyProcess _DiyProcess;

        /// <summary>
        /// 
        /// </summary>
        public AddDiyProcess(DiyProcess diyProcess)
        {
            _DiyProcess = diyProcess;
        }

        /// <summary>
        /// 
        /// </summary>
        public AddDiyProcess(DiyProcess diyProcess, IDiyProcessDal mockIDiyProcessDal)
        {
            _DiyProcess = diyProcess;
            _IDiyProcessDal = mockIDiyProcessDal;
        }

        protected override void Validation()
        {
            if(_IDiyProcessDal.CountDiyProcessByName(_DiyProcess.Name)>0)
            {
                HrmisUtility.ThrowException(HrmisUtility._DiyProcess_Name_Repeat);
            }
        }

        protected override void ExcuteSelf()
        {
            try
            {
                _IDiyProcessDal.InsertDiyProcess(_DiyProcess);

            }
            catch
            {
                BllUtility.ThrowException(BllExceptionConst._DbError);
            }
        }
    }
}
