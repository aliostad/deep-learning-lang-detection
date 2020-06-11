using Api.Bestellwesen;
using Api.Kunden;
using Api.Meta;
using Api.Warenkorb;
using Api.Warenwirtschaft;

namespace Api
{
    public abstract class CqrsGmbH
    {
        public abstract KundenApi Kunden { get; protected set; }
        public abstract WarenkorbApi Warenkorb { get; protected set; }
        public abstract WarenwirtschaftApi Warenwirtschaft { get; protected set; }
        public abstract BestellwesenApi Bestellwesen { get; protected set; }
        public abstract MetaApi Meta { get; protected set; }
    }
}


