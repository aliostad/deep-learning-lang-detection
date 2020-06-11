using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RWPLDataService.Model
{
    public class Dispatch : Entity
    {
        public Dispatch()
        {
            DispatchItems=new List<DispatchItem>();
        }

        public DateTime Date { get; set; }

        public DateTime InTime { get; set; }

        public DateTime OutTime { get; set; }

        public string Client { get; set; }

        public string VehicalNo { get; set; }

        public string DriverName { get; set; }

        public ICollection<DispatchItem> DispatchItems { get; set; }
    }
}
