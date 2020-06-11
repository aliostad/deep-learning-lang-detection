using SetGenerator.Domain.Entities;
using FluentNHibernate.Mapping;

namespace SetGenerator.Domain.Mappings
{
    public sealed class SongMemberInstrumentMap : ClassMap<SongMemberInstrument>
    {
        public SongMemberInstrumentMap()
        {
            Table("SongMemberInstrument");

            Id(x => x.Id).Column("Id");
            References(m => m.Song).Column("SongId");
            References(m => m.Member).Column("MemberId");
            References(m => m.Instrument).Column("InstrumentId");
        }
    }
}