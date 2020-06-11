using NSubstitute;
using Ploeh.AutoFixture;
using Ploeh.AutoFixture.AutoNSubstitute;
using Ploeh.AutoFixture.Xunit;

namespace DotNext.RockAndRoll.UnitTests
{
    public class AutoMockDataAttribute : AutoDataAttribute
    {
        public AutoMockDataAttribute() : base(
            new Fixture().Customize(
                new AutoNSubstituteCustomization())) {}
    }

    public class ReadyToRockInstrumentAttribute : AutoMockDataAttribute
    {
        public ReadyToRockInstrumentAttribute()
        {
            var instrument = Substitute.For<IInstrument>();
            instrument.Status = InstrumentStatus.ReadyToRock;
            Fixture.Inject(instrument);
        }
    }

    public class BrokenInstrumentAttribute : AutoMockDataAttribute
    {
        public BrokenInstrumentAttribute()
        {
            var instrument = Substitute.For<IInstrument>();
            instrument.Status = InstrumentStatus.Broken;
            Fixture.Inject(instrument);
        }
    }
}