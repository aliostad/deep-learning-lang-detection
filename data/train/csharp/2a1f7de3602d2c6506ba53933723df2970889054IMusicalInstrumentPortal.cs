using COSC4210.MusicalIntruments.Web.Data_Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace COSC4210.MusicalIntruments.Web.Instruments
{
    public interface IMusicalInstrumentPortal
    {
        IList<MusicalInstrument> GetMusicalInstruments();

        void SaveMusicalInstrument(MusicalInstrument MusicalInstrument);

        MusicalInstrument GetMusicalInstrument(int ID);

        IList<InstrumentType> GetInstrumentTypes();

        void SaveInstrumentType(InstrumentType instrumentType);

        InstrumentType GetInstrumentType(int ID);

        IList<InstrumentCategory> GetInstrumentCategories();

        void SaveInstrumentCategory(InstrumentCategory instrumentCategory);

        InstrumentCategory GetInstrumentCategory(int ID);

        IList<Data_Contracts.InstrumentCategory> DeleteCategoryAssociation(int InstrumentID, int CategoryID);

        IList<Data_Contracts.InstrumentCategory> GetCategoryAssociations(int InstrumentID);

        IList<Data_Contracts.InstrumentCategory> AddCategoryAssociation(int InstrumentID, int CategoryID);
        

    }
}