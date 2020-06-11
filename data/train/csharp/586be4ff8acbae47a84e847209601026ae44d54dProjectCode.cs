using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Cats.Models.Hubs
{
    public partial class ProjectCode
    {
        public ProjectCode()
        {
            this.DispatchAllocations = new List<DispatchAllocation>();
            this.OtherDispatchAllocations = new List<OtherDispatchAllocation>();
            this.Transactions = new List<Transaction>();
        }
        [Key]
        public int ProjectCodeID { get; set; }
        public string Value { get; set; }
        public virtual ICollection<DispatchAllocation> DispatchAllocations { get; set; }
        public virtual ICollection<OtherDispatchAllocation> OtherDispatchAllocations { get; set; }
        public virtual ICollection<Transaction> Transactions { get; set; }
    }
}
