using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DRMFSS.BLL
{
    public partial class ShippingInstruction
    {
        public ShippingInstruction()
        {
            this.DispatchAllocations = new List<DispatchAllocation>();
            this.OtherDispatchAllocations = new List<OtherDispatchAllocation>();
            this.Transactions = new List<Transaction>();
        }
        [Key]
        public int ShippingInstructionID { get; set; }
        public string Value { get; set; }
        public virtual ICollection<DispatchAllocation> DispatchAllocations { get; set; }
        public virtual ICollection<OtherDispatchAllocation> OtherDispatchAllocations { get; set; }
        public virtual ICollection<Transaction> Transactions { get; set; }
    }
}
