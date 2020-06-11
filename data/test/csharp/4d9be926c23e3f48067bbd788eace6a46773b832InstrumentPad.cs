using System;
using Gtk;
using System.Linq;
using MonoDevelop.Components;
using MonoDevelop.Components.Docking;
using MonoDevelop.Core;
using MonoDevelop.Ide;
using MonoDevelop.Ide.Gui;
using MonoDevelop.Ide.Gui.Components;
using MonoDevelop.Ide.Gui.Pads;
using MonoDevelop.DesignerSupport;
using SmartQuant;
using System.Collections.Generic;

namespace MequantaStudio.SmartQuant
{
    public enum InstrumentGroupMethod
    {
        Alphabetically,
        ByCurrency,
        ByExchange,
        ByInstrumentType,
        ByMaturity,
        NoGroup
    }

    public class InstrumentPad : TreeViewPad
    {
        List<InstrumentNode> instrumentNodes = new List<InstrumentNode>();
        InstrumentGroupMethod groupMethod = InstrumentGroupMethod.NoGroup;
        Button buttonrefresh;
        MenuButton buttonGroup;
        Gtk.MenuToolButton menuTool;

        public InstrumentGroupMethod GroupMethod
        {
            get {
                return groupMethod;
                }
            set
            {
                if (groupMethod == value)
                    return;
                groupMethod = value;
                LoadTree();
            }
        }

        public override void Initialize(NodeBuilder[] builders, TreePadOption[] options, string contextMenuPath)
        {
            base.Initialize(builders, options, contextMenuPath);
            var topToolbar = Window.GetToolbar(PositionType.Top);

            // Group button
            buttonGroup = new MenuButton();
            buttonGroup.StockImage = MonoDevelop.Ide.Gui.Stock.GroupByCategory;
            buttonGroup.ArrowType = ArrowType.Down;
            buttonGroup.TooltipText = GettextCatalog.GetString("Group instruments");
            buttonGroup.MenuCreator = delegate
            {
                var menu = new Menu();
                var mi = new Gtk.RadioMenuItem("Alphabetically");
                var g = mi.Group;
                mi.Active = groupMethod == InstrumentGroupMethod.Alphabetically;
                mi.Activated += (sender, e) =>
                {
                    groupMethod = InstrumentGroupMethod.Alphabetically;
                };
                menu.Insert(mi, -1);

                mi = new Gtk.RadioMenuItem(g, "By Currency");
                mi.Active = groupMethod == InstrumentGroupMethod.ByCurrency;
                mi.Activated += (sender, e) =>
                {
                    groupMethod = InstrumentGroupMethod.ByCurrency;
                };
                menu.Insert(mi, -1);

                mi = new Gtk.RadioMenuItem(g, "By Exchange");
                mi.Active = groupMethod == InstrumentGroupMethod.ByExchange;
                mi.Activated += (sender, e) =>
                {
                    groupMethod = InstrumentGroupMethod.ByExchange;
                };
                menu.Insert(mi, -1);

                mi = new Gtk.RadioMenuItem(g, "By Instrument Type");
                mi.Active = groupMethod == InstrumentGroupMethod.ByInstrumentType;
                mi.Activated += (sender, e) =>
                {
                    groupMethod = InstrumentGroupMethod.ByInstrumentType;
                };
                menu.Insert(mi, -1);

                mi = new Gtk.RadioMenuItem(g, "By Maturity");
                mi.Active = groupMethod == InstrumentGroupMethod.ByMaturity;
                mi.Activated += (sender, e) =>
                {
                    groupMethod = InstrumentGroupMethod.ByMaturity;
                };
                menu.Insert(mi, -1);

                mi = new Gtk.RadioMenuItem(g, "No Group");
                mi.Active = groupMethod == InstrumentGroupMethod.NoGroup;
                mi.Activated += (sender, e) =>
                {
                    groupMethod = InstrumentGroupMethod.NoGroup;
                };
                menu.Insert(mi, -1);
                menu.ShowAll();
                return menu;
            };

            topToolbar.Add(buttonGroup);

            // Refresh button
            buttonrefresh = new Button();
            buttonrefresh.Image = new Gtk.Image(Gtk.Stock.Refresh, IconSize.SmallToolbar);
            buttonrefresh.TooltipText = GettextCatalog.GetString("Refresh instruments");
            topToolbar.Add(buttonrefresh);

            menuTool = new MenuToolButton(Gtk.Stock.Cdrom);
            topToolbar.Add(menuTool);

            topToolbar.ShowAll();

            // Tree
            TreeView.Tree.Selection.Mode = SelectionMode.Single;
            LoadTree();

            Control.ShowAll();

            var f = Framework.Current;
            f.EventManager.Dispatcher.InstrumentAdded += OnInstrumentAdded;
            f.EventManager.Dispatcher.InstrumentDeleted += OnInstrumentDeleted;

            foreach (var instrument in Framework.Current.InstrumentManager.Instruments)
                instrumentNodes.Add(new InstrumentNode(instrument));

            var byExchange = from instrumentNode in instrumentNodes
                group instrumentNode by instrumentNode.Instrument.CurrencyId;
            foreach (var customerGroup in byExchange)
            {
                Console.WriteLine(customerGroup.Key);
                foreach (var customer in customerGroup)
                {
                    Console.WriteLine("    {0}", customer.Instrument.Symbol);
                }
            }

            var byAlpha = from instrumentNode in instrumentNodes
                group instrumentNode by instrumentNode.Instrument.Symbol[0];
            foreach (var customerGroup in byAlpha)
            {
                Console.WriteLine(customerGroup.Key);
                foreach (var customer in customerGroup)
                {
                    Console.WriteLine("    {0}", customer.Instrument.Symbol);
                }
            }

            var byCurrency = from instrumentNode in instrumentNodes
                group instrumentNode by instrumentNode.Instrument.CurrencyId;
            foreach (var customerGroup in byCurrency)
            {
                Console.WriteLine(customerGroup.Key);
                foreach (var customer in customerGroup)
                {
                    Console.WriteLine("    {0}", customer.Instrument.Symbol);
                }
            }

            var byType = from instrumentNode in instrumentNodes
                group instrumentNode by instrumentNode.Instrument.Type;
            foreach (var customerGroup in byType)
            {
                Console.WriteLine(customerGroup.Key);
                foreach (var customer in customerGroup)
                {
                    Console.WriteLine("    {0}", customer.Instrument.Symbol);
                }
            }

            var byMaturity = from instrumentNode in instrumentNodes
                group instrumentNode by instrumentNode.Instrument.Maturity;
            foreach (var customerGroup in byMaturity)
            {
                Console.WriteLine(customerGroup.Key);
                foreach (var customer in customerGroup)
                {
                    Console.WriteLine("    {0}", customer.Instrument.Symbol);
                }
            }
        }

        void HandleActivated(object sender, EventArgs e)
        {
            var mi = sender as Gtk.RadioMenuItem;
            //Console.WriteLine("mi:{0}",mi.);
        }

        protected override void OnSelectionChanged(object sender, EventArgs args)
        {
        }

        public override void Dispose()
        {
            var f = Framework.Current;
            f.EventManager.Dispatcher.InstrumentAdded -= OnInstrumentAdded;
            f.EventManager.Dispatcher.InstrumentDeleted -= OnInstrumentDeleted;
            base.Dispose();
        }

        private void LoadInstrument()
        {
            var f = Framework.Current;
            foreach (var instrument in f.InstrumentManager.Instruments)
                instrumentNodes.Add(new InstrumentNode(instrument));
        }

        private void LoadTree()
        {
            TreeView.Clear();
            foreach (var node in GetInstrumentRootNodes(groupMethod))
                TreeView.AddChild(node);
        }

        private object[] GetInstrumentRootNodes(InstrumentGroupMethod method)
        {
            return GetRootNodesNoGroup();
        }

        private object[] GetRootNodesNoGroup()
        {
            var instFolder = new InstrumentFolderNode("Instruments");
            foreach (var instrument in Framework.Current.InstrumentManager.Instruments)
                instFolder.Instruments.Add(new InstrumentNode(instrument));
            return new object[] { instFolder };
        }

        private void OnInstrumentAdded(object sender, InstrumentEventArgs args)
        {
            Gtk.Application.Invoke(delegate
            {
                AddInstrument(args.Instrument);
            });
        }

        private void OnInstrumentDeleted(object sender, InstrumentEventArgs args)
        {
            Gtk.Application.Invoke(delegate
            {
                RemoveInstrument(args.Instrument);
            });
        }

        private void AddInstrument(Instrument instrument)
        {
        }

        private void RemoveInstrument(Instrument instrument)
        {
        }

        private Menu createMenu()
        {
            var menu = new Menu();
            var mi = new Gtk.RadioMenuItem("Alphabetically");
            var g = mi.Group;
            mi.Active = groupMethod == InstrumentGroupMethod.Alphabetically;
            mi.Activated += (sender, e) =>
            {
                groupMethod = InstrumentGroupMethod.Alphabetically;
            };
            menu.Insert(mi,-1);

            mi = new Gtk.RadioMenuItem(g, "By Currency");
            mi.Active = groupMethod == InstrumentGroupMethod.ByCurrency;
            mi.Activated += (sender, e) =>
            {
                groupMethod = InstrumentGroupMethod.ByCurrency;
            };
            menu.Insert(mi,-1);

            mi = new Gtk.RadioMenuItem(g, "By Exchange");
            mi.Active = groupMethod == InstrumentGroupMethod.ByExchange;
            mi.Activated += (sender, e) =>
            {
                groupMethod = InstrumentGroupMethod.ByExchange;
            };
            menu.Insert(mi,-1);

            mi = new Gtk.RadioMenuItem(g, "By Instrument Type");
            mi.Active = groupMethod == InstrumentGroupMethod.ByInstrumentType;
            mi.Activated += (sender, e) =>
            {
                groupMethod = InstrumentGroupMethod.ByInstrumentType;
            };
            menu.Insert(mi,-1);

            mi = new Gtk.RadioMenuItem(g, "By Maturity");
            mi.Active = groupMethod == InstrumentGroupMethod.ByMaturity;
            mi.Activated += (sender, e) =>
            {
                groupMethod = InstrumentGroupMethod.ByMaturity;
            };
            menu.Insert(mi,-1);

            mi = new Gtk.RadioMenuItem(g, "No Group");
            mi.Active = groupMethod == InstrumentGroupMethod.NoGroup;
            mi.Activated += (sender, e) =>
            {
                groupMethod = InstrumentGroupMethod.NoGroup;
            };
            menu.Insert(mi,-1);
            menu.ShowAll();
            return menu;
        }
    }
}
