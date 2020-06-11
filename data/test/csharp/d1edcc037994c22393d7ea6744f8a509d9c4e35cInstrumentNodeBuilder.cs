using System;
using MonoDevelop.Ide.Gui.Components;
using System.Collections.Generic;
using MonoDevelop.DesignerSupport;
using MonoDevelop.Core;
using MonoDevelop.Ide.Gui;
using SmartQuant;

namespace MequantaStudio.SmartQuant
{
    public class InstrumentNode
    {
        public Instrument Instrument { get; private set; }

        public InstrumentNode(Instrument instrument)
        {
            Instrument = instrument;
        }
    }

    public class InstrumentNodeBuilder : TypeNodeBuilder
    {
        public override Type NodeDataType
        {
            get
            { 
                return typeof(InstrumentNode);
            }
        }

        public override Type CommandHandlerType
        {
            get
            { 
                return typeof(InstrumentNodeCommandHandler);
            }
        }

        public override string ContextMenuAddinPath
        {
            get
            { 
                return "/MequantaStudio/SmartQuant/ContextMenu/InstrumentPad/InstrumentNode";
            }
        }

        public override string GetNodeName(ITreeNavigator thisNode, object dataObject)
        {
            return ((InstrumentNode)dataObject).Instrument.Symbol;
        }

        public override bool HasChildNodes(ITreeBuilder builder, object dataObject)
        {
            return false;
        }

        public override void BuildNode(ITreeBuilder treeBuilder, object dataObject, NodeInfo nodeInfo)
        {
            var node = dataObject as InstrumentNode;
            nodeInfo.Label = node.Instrument.Symbol;
            nodeInfo.Icon = Context.GetIcon("ms-sq-instrument");
        }
    }

    public class InstrumentNodePropertyProvider : IPropertyProvider
    {
        public bool SupportsObject(object obj)
        {
            return obj is InstrumentNode;
        }

        public object CreateProvider(object obj)
        {
            return new InstrumentNodeDescriptor((InstrumentNode)obj);
        }
    }

    public class InstrumentNodeDescriptor : CustomDescriptor
    {
        private InstrumentNode instrumentNode;

        public InstrumentNodeDescriptor(InstrumentNode instrumentNode)
        {
            this.instrumentNode = instrumentNode;
        }

        [LocalizedCategory("appearance")]
        [LocalizedDisplayName("Symbol")]
        [LocalizedDescription("instrument symbol")]
        public string Symbol
        {
            get
            {
                return this.instrumentNode.Instrument.Symbol;
            }
        }
    }

    public class InstrumentFolderNode
    {
        public InstrumentFolderNode(string label)
        {
            Instruments = new List<InstrumentNode>();
            Label = label;
        }

        public string Label { get; set; }

        public List<InstrumentNode> Instruments { get; set; }
    }

    public class InstrumentFolderNodeBuilder : TypeNodeBuilder
    {
        public override Type NodeDataType
        {
            get
            {
                return typeof(InstrumentFolderNode);
            }
        }

        public override Type CommandHandlerType
        {
            get
            { 
                return typeof(InstrumentFolderNodeCommandHandler);
            }
        }

        public override string ContextMenuAddinPath
        {
            get
            { 
                return "/MequantaStudio/SmartQuant/ContextMenu/InstrumentPad/InstrumentFolderNode"; 
            }
        }

        public override string GetNodeName(ITreeNavigator thisNode, object dataObject)
        {

            return ((InstrumentFolderNode)dataObject).Label;
        }

        public override void BuildNode(ITreeBuilder treeBuilder, object dataObject, NodeInfo nodeInfo)
        {
            var folder = dataObject as InstrumentFolderNode;
            nodeInfo.Label = folder.Label;
            nodeInfo.Icon = Context.GetIcon(Stock.OpenFolder);
            nodeInfo.ClosedIcon = Context.GetIcon(Stock.ClosedFolder);
        }

        public override void BuildChildNodes(ITreeBuilder builder, object dataObject)
        {
            var folder = dataObject as InstrumentFolderNode;
            foreach (var instrument in folder.Instruments)
                builder.AddChild(instrument);
        }

        public override bool HasChildNodes(ITreeBuilder builder, object dataObject)
        {
            return true;
        }
    }
}

