using Xamarin.Forms;

namespace Stepquencer
{
    /// <summary>
    /// A button that represents an instrument. It has a reference to it's instrument and
    /// updates it's appearance to match the instrument it is assigned
    /// </summary>
    public class InstrumentButton : Button
    {
        private Instrument instrument;

        /// <summary>
        /// Note: setting the instrument also sets the appearance of this button
        /// </summary>
        public Instrument Instrument
        {
            get { return instrument; }
            set
            {
                this.instrument = value;
                this.Image = App.isTablet ? $"{instrument.name}_Tab.png" : $"{instrument.name}.png";
                this.BackgroundColor = instrument.color;
            }
        }

        /// <summary>
        /// A selected instrument button has a white border
        /// </summary>
        public bool Selected
        {
            get { return BorderColor == Color.White; }
            set
            {
                this.BorderColor = value ? Color.White : Color.Black;
            }
        }

        public InstrumentButton(Instrument instrument) : base()
        {
            this.Instrument = instrument;

            this.BorderWidth = 3;
            this.Selected = false;
        }
    }
}
