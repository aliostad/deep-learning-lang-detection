using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DRMFSS.BLL
{
    public partial class Transporter
    {
        public Transporter()
        {
            this.Dispatches = new List<Dispatch>();
            this.DispatchAllocations = new List<DispatchAllocation>();
            this.OtherDispatchAllocations = new List<OtherDispatchAllocation>();
            this.Receives = new List<Receive>();
        }
        [Key]
        public int TransporterID { get; set; }
        public string Name { get; set; }
        public string NameAM { get; set; }
        public string LongName { get; set; }
        public string BiddingSystemID { get; set; }
        public virtual ICollection<Dispatch> Dispatches { get; set; }
        public virtual ICollection<DispatchAllocation> DispatchAllocations { get; set; }
        public virtual ICollection<OtherDispatchAllocation> OtherDispatchAllocations { get; set; }
        public virtual ICollection<Receive> Receives { get; set; }
    }
}
