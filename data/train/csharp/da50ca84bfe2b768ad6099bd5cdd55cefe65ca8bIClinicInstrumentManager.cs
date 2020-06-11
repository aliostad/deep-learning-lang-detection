using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DENTALMIS.Model;

namespace DENTALMIS.BLL.IManager.IClinicSectionManager
{
  public  interface IClinicInstrumentManager
    {
      List<ClinicalInstrument> GetAllInstrumentByPaging(out int totalrecords, ClinicalInstrument model);

      ClinicalInstrument GetInstrumentById(int id);

      int Save(ClinicalInstrument clinicalInstrument);

      int Edit(ClinicalInstrument clinicalInstrument);

      int Delete(int id);
    }
}
