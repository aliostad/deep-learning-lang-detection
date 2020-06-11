using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace com.primebird.portal.core.Entities
{
    public class DispatchIdentifier
    {
        public virtual Dispatch dispatch { get; set; }
        public virtual string alternate_identifier { get; set; }

        public override bool Equals(object obj)
        {
            if (obj.GetType() != typeof(DispatchIdentifier))
                return false;

            DispatchIdentifier b = obj as DispatchIdentifier;

            return b.dispatch == this.dispatch && b.alternate_identifier == this.alternate_identifier;
        }

        public override int GetHashCode()
        {
            return (this.dispatch.id + this.alternate_identifier).GetHashCode();
        }
    }
}
