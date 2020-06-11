namespace PCF.REDCap
{
    public class Instrument
    {
        public string InstrumentName { get; set; }
        public string InstrumentLabel { get; set; } // Key

        public override string ToString()
        {
            return InstrumentName;
        }

        public override bool Equals(object obj)
        {
            var x = obj as Instrument;

            if (x == null)
                return false;

            return this.InstrumentName == x.InstrumentName;
        }

        public override int GetHashCode()
        {
            return this.InstrumentName.GetHashCode();
        }
    }
}