using FreeQuant.Instruments;
using System.Collections.Generic;
using System.Windows.Forms;

namespace OpenQuant.Shared.Instruments
{
	class GroupNode : TreeNode
	{
		protected Dictionary<Instrument, InstrumentNode> instrumentNodes;

		public Instrument[] Instruments
		{
			get
			{
				return new List<Instrument>((IEnumerable<Instrument>)this.instrumentNodes.Keys).ToArray();
			}
		}

		public GroupNode()
		{
			this.instrumentNodes = new Dictionary<Instrument, InstrumentNode>();
			this.SetText("Undefined");
			this.UpdateIcon();
		}

		public void UpdateIcon()
		{
			this.ImageIndex = this.SelectedImageIndex = this.IsExpanded ? 2 : 1;
		}

		public void AddInstrument(Instrument instrument)
		{
			if (this.instrumentNodes.ContainsKey(instrument))
				return;
			InstrumentNode instrumentNode = new InstrumentNode(instrument);
			this.instrumentNodes.Add(instrument, instrumentNode);
			this.Nodes.Add(instrumentNode);
			this.UpdateToolTipText();
		}

		public void RemoveInstrument(Instrument instrument)
		{
			if (!this.instrumentNodes.ContainsKey(instrument))
				return;
			InstrumentNode instrumentNode = this.instrumentNodes[instrument];
			this.instrumentNodes.Remove(instrument);
			instrumentNode.Remove();
			if (this.Nodes.Count == 0)
				this.Remove();
			else
				this.UpdateToolTipText();
		}

		public virtual bool IsInstrumentValid(Instrument instrument)
		{
			return false;
		}

		protected void SetText(string text)
		{
			if (string.IsNullOrEmpty(text))
				this.Text = "-";
			else
				this.Text = text;
		}

		private void UpdateToolTipText()
		{
			this.ToolTipText = string.Format("{0:n0} instrument(s)", this.instrumentNodes.Count);
		}
	}
}
