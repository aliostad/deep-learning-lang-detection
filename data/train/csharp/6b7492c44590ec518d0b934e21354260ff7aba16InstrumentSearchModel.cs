using System.ComponentModel;
namespace FuzzyLogicSearch.Model
{
    public class InstrumentSearchModel
    {
        public string Identifier { get; set; }
        public string InstrumentName { get; set; }
        public double MatchLikelihood { get; set; }

        public InstrumentSearchModel(string instrumentIdentifier, string instrumentName, double matchLikelihood)
        {
            // TODO: Complete member initialization
            this.Identifier = instrumentIdentifier;
            this.InstrumentName = instrumentName;
            this.MatchLikelihood = matchLikelihood;
        }

    }
}
