using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DENTALMIS.BLL.IManager.IClinicSectionManager;
using DENTALMIS.DAL;
using DENTALMIS.DAL.IRepository.IClinicSectionRepository;
using DENTALMIS.DAL.Repository.ClinicSectionRepository;
using DENTALMIS.Model;

namespace DENTALMIS.BLL.Manager.ClinicSectionManager
{
  public  class ClinicInstrumentManager :IClinicInstrumentManager
  {
      private IClinicInstrumentRepository _clinicInstrumentRepository= null;


      public ClinicInstrumentManager(DENTALERPDbContext context)
      {
         _clinicInstrumentRepository=new ClinicInstrumentRepository(context);
      }

      public List<ClinicalInstrument> GetAllInstrumentByPaging(out int totalrecords, ClinicalInstrument model)
      {

          List<ClinicalInstrument> clinicalInstruments;
          try
          {
              clinicalInstruments = _clinicInstrumentRepository.GetAllInstrumentByPaging(out totalrecords, model);
          }
          catch (Exception exception)
          {

              throw new Exception(exception.Message);
          }

          return clinicalInstruments;
      }

      public ClinicalInstrument GetInstrumentById(int id)
      {
          ClinicalInstrument clinicalInstrument;
          try
          {
              clinicalInstrument = _clinicInstrumentRepository.FindOne(x => x.InstrumentId == id && x.IsActive == true);
          }
          catch (Exception exception)
          {

              throw new Exception(exception.Message);
          }
         return clinicalInstrument;
      }

      public int Save(ClinicalInstrument clinicalInstrument)
      {
          int saveIndex = 0;

          try
          {
              clinicalInstrument.IsActive = true;
              saveIndex = _clinicInstrumentRepository.Save(clinicalInstrument);
          }
          catch (Exception exception)
          {

              throw new Exception(exception.Message);
          }
          return saveIndex;
      }

      public int Edit(ClinicalInstrument clinicalInstrument)
      {
          int editIndex = 0;
          try
          {
              ClinicalInstrument _clinicalInstrument = GetInstrumentById(clinicalInstrument.InstrumentId);
              _clinicalInstrument.InstrumentId = clinicalInstrument.InstrumentId;
              _clinicalInstrument.Name = clinicalInstrument.Name;
              _clinicalInstrument.Description = clinicalInstrument.Description;
              _clinicalInstrument.Market = clinicalInstrument.Market;

              editIndex = _clinicInstrumentRepository.Edit(_clinicalInstrument);
          }
          catch (Exception exception)
          {

              throw new Exception(exception.Message);
          }
          return editIndex;
      }

      public int Delete(int id)
      {
          int deleteIndex = 0;
          try
          {
              ClinicalInstrument clinicalInstrument = GetInstrumentById(id);

              clinicalInstrument.IsActive = false;

              deleteIndex = _clinicInstrumentRepository.Edit(clinicalInstrument);
          }
          catch (Exception exception)
          {

              throw new Exception(exception.Message);
          }
          return deleteIndex;
      }
  }
}
