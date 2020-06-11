using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using TomiSoft.RolandStyleReader;

namespace TomiSoft_Style_Studio {
	public partial class InstrumentSelector : UserControl {
		private Instrument selectedInstr = Instrument.Drum;
		
		public Instrument SelectedInstrument {
			get {
				return this.selectedInstr;
			}
		}

		public event EventHandler<InstrumentEventArgs> InstrumentChanged;

		public InstrumentSelector() {
			InitializeComponent();

			Dictionary<RadioButton, Instrument> Mappings = new Dictionary<RadioButton, Instrument>() {
				{radioButton1, Instrument.Drum},
				{radioButton2, Instrument.Bass},
				{radioButton3, Instrument.Acc1},
				{radioButton4, Instrument.Acc2},
				{radioButton5, Instrument.Acc3},
				{radioButton6, Instrument.Acc4},
				{radioButton7, Instrument.Acc5},
				{radioButton8, Instrument.Acc6},
			};

			foreach (var item in Mappings) {
				item.Key.CheckedChanged += (o, e) => {
					if (item.Key.Checked)
						this.OnChanged(item.Value);
				};
			}
		}

		private void OnChanged(Instrument i) {
			this.selectedInstr = i;
			if (this.InstrumentChanged != null)
				this.InstrumentChanged(this, new InstrumentEventArgs(i));
		}
	}
}
