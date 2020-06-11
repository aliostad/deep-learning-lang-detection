using com.primebird.portal.core.Entities;
using FluentNHibernate.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace com.primebird.portal.core.Mappings.NHibernate
{
    public class DispatchIdentifierMap : ClassMap<DispatchIdentifier>
    {
        public DispatchIdentifierMap()
        {
            Schema("dispatch");
            Table("dispatch_identifier");
            CompositeId()
                .KeyReference(x => x.dispatch, "dispatch_id").Mapped()
                .KeyProperty(x => x.alternate_identifier);
        }
    }
}
