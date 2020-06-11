using System;
using SmartQuant;
using System.Collections.Generic;

namespace MequantaStudio.SmartQuant
{
    public partial class ImportInstrumentWidget: Gtk.Bin
    {
        private IInstrumentProvider provider;
        private string requestId;
        private List<Instrument> instruments = new List<Instrument>();

        public ImportInstrumentWidget(string providerName)
        {
            this.Build();
            var f = Framework.Current;
            this.provider = f.ProviderManager.GetProvider(providerName) as IInstrumentProvider;

            f.EventManager.Dispatcher.InstrumentDefinition += new InstrumentDefinitionEventHandler(this.OnInstrumentDefinition);
            f.EventManager.Dispatcher.InstrumentDefinitionEnd += new InstrumentDefinitionEndEventHandler(this.OnInstrumentDefinitionEnd);
        }

        protected override void OnDestroyed()
        {
            var f = Framework.Current;
            f.EventManager.Dispatcher.InstrumentDefinition -= new InstrumentDefinitionEventHandler(this.OnInstrumentDefinition);
            f.EventManager.Dispatcher.InstrumentDefinitionEnd -= new InstrumentDefinitionEndEventHandler(this.OnInstrumentDefinitionEnd);
            base.OnDestroyed();
        }

        private void OnInstrumentDefinition(object sender, InstrumentDefinitionEventArgs args)
        {
            InstrumentDefinition definition = args.Definition;
            if (definition.RequestId != this.requestId)
                return;
            this.instruments.AddRange((IEnumerable<Instrument>)definition.Instruments);
            Gtk.Application.Invoke(delegate
            {
                if (definition.TotalNum <= 0)
                    return;
                double num = (double)this.instruments.Count / (double)definition.TotalNum * 100.0;
                if (num > 100.0)
                    num = 100.0;
//                    this.tsiProgress.Value = (int)num;
            });
        }

        private void OnInstrumentDefinitionEnd(object sender, InstrumentDefinitionEndEventArgs args)
        {
            InstrumentDefinitionEnd end = args.End;
            if (end.RequestId != this.requestId)
                return;
            this.requestId = null;
            Gtk.Application.Invoke(delegate
            {
                //                    this.ltvInstruments.BeginUpdate();
                //                    this.ltvInstruments.Items.Clear();
                //                    foreach (Instrument instrument in this.instruments)
                //                        this.ltvInstruments.Items.Add((ListViewItem) new InstrumentViewItem(instrument));
                //                    this.ltvInstruments.EndUpdate();
                //                    this.gbxFilter.Enabled = true;
                //                    this.btnRequest.Visible = true;
                //                    this.btnCancel.Visible = false;
                //                    if (this.instruments.Count > 0)
                //                        this.btnImport.Visible = true;
                //                    this.ltvInstruments.Enabled = true;
                //                    this.tsiInfo.Text = string.Format("{0} - {1}", (object) end.Result, (object) end.Text);
                //                    this.tsiProgress.Visible = false;
            }); 
        }
    }
}

