using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace wsRDIntegration
{
    public class DispatchNote
    {

        [DataMember]
        public String DispatchID;
        [DataMember]
        public int GRNNo;

        public DispatchNote(String _DispatchID, int _GRNNo)
        {
            this.DispatchID = _DispatchID;
            this.GRNNo = _GRNNo;
        }

        public DispatchNote()
        {
            // TODO: Complete member initialization
        }

    }
}
