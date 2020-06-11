using Final_Project.DAL.Gateway;
using Final_Project.DAL.Model;

namespace Final_Project.BLL
{
    class InstrumentManager
    {
        InstrumentGateway aInstrumentGateway = new InstrumentGateway();
        public string Add(Instrument aClinical)
        {
            if (aInstrumentGateway.SearchID(aClinical.PatientId) == null)
            {
                if (aInstrumentGateway.Add(aClinical) != null)
                {
                    return "Successfully Added Instrument info";
                }
            }
            return "Faild's Added Instrument info";
        }

        public Instrument SearchID(string id)
        {
            return aInstrumentGateway.SearchID(id);
        }

        public string Update(Instrument aInstrument)
        {
            if (aInstrumentGateway.Update(aInstrument) >= 0)
            {
                return "Successfully Update a Instrument Info";
            }
            return "Faild's to Update";
        }
    }
}
