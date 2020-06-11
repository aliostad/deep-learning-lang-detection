using System;
using MonoDevelop.Components.Commands;
using MonoDevelop.Ide;
using MonoDevelop.Ide.Gui;
using SmartQuant;
using Gtk;
using MonoDevelop.Ide.Gui.Components;

namespace  MequantaStudio.SmartQuant
{
    public enum InstrumentNodeCommands
    {
        AddNew,
        ViewData,
        Delete
    }

    public class InstrumentNodeCommandHandler : PropertyNodeCommandHandler
    {
        public override void ActivateItem()
        {
            var instrument = CurrentNode.DataItem as InstrumentNode;
            Console.WriteLine("{0}", instrument.Instrument.Symbol);   
        }

        [CommandUpdateHandler(InstrumentNodeCommands.AddNew)]
        public void UpdateAddNew(CommandInfo ci)
        {
            var instrument = CurrentNode.DataItem as InstrumentNode;
            ci.Visible = true;
        }

        [CommandHandler(InstrumentNodeCommands.AddNew)]
        public void AddNew()
        {
            var instrument = CurrentNode.DataItem as InstrumentNode;
            using (var dlg = new NewInstrumentDialog())
            {
                if ((int)ResponseType.Ok == MessageService.RunCustomDialog(dlg))
                {
//                    var newInstrument = new Instrument(dlg.InstrumentType, dlg.Symbol, "", dlg.CurrencyId);
//                    newInstrument.Maturity = dlg.Maturity;
//                    newInstrument.Exchange = dlg.Exchange;
//                    newInstrument.Strike = dlg.Strike;
//                    var f = Framework.Current;
//                    f.InstrumentManager.Add(newInstrument);
//                    f.InstrumentServer.Flush();
                }
            }
        }

        [CommandUpdateHandler(InstrumentNodeCommands.ViewData)]
        public void UpdateOpenData(CommandInfo ci)
        {
            var instrument = CurrentNode.DataItem as InstrumentNode;
            ci.Visible = true;
        }

        [CommandHandler(InstrumentNodeCommands.ViewData)]
        public void OpenData()
        {
            var instrument = CurrentNode.DataItem as InstrumentNode;
            string contentId = string.Format("Data [{0}]", instrument.Instrument.Symbol);
            IdeApp.Workbench.OpenDocument(new InstrumentDataWidget(instrument.Instrument.Symbol), contentId, true);
        }

        [CommandUpdateHandler(InstrumentNodeCommands.Delete)]
        public void UpdateDelete(CommandInfo ci)
        {
            var instrument = CurrentNode.DataItem as InstrumentNode;
            ci.Visible = instrument != null;

//            foreach(var instrument in list)
//                Framework.Current.InstrumentManager.Delete(instrument);
        }

        [CommandHandler(InstrumentNodeCommands.Delete)]
        public void Delete()
        {
            if (MessageService.Confirm("Delete?", AlertButton.Yes))
            {
                var f = Framework.Current;
                foreach (var node in CurrentNodes)
                {        
                    var instrument = ((InstrumentNode)node.DataItem).Instrument;
//                f.InstrumentManager.Delete(instrument);
                }
            }
        }
    }

    public class InstrumentFolderNodeCommandHandler : NodeCommandHandler
    {
        public override void ActivateItem()
        {
            CurrentNode.Expanded = !CurrentNode.Expanded;
        }
    }
}