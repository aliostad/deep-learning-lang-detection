using SmartQuant;
using System;
using System.Windows.Forms;

namespace SmartQuant.Controls.Data.Import.Instruments
{
  internal class InstrumentViewItem : ListViewItem
  {
    public Instrument Instrument { get; private set; }

    public InstrumentViewItem(Instrument instrument)
      : base(new string[5])
    {
      this.Instrument = instrument;
      this.SubItems[0].Text = instrument.Symbol;
      this.SubItems[1].Text = instrument.Type.ToString();
      this.SubItems[2].Text = instrument.Exchange;
      this.SubItems[3].Text = CurrencyId.GetName(instrument.CurrencyId);
      this.SubItems[4].Text = instrument.Maturity == DateTime.MinValue ? string.Empty : instrument.Maturity.ToShortDateString();
    }
  }
}
