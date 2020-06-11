using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1.FTStream
{
    public interface IPropertyProcess
    {
        void ParseMarker(byte[] buffer, ref int pos);
        void ParseMetaProperty(byte[] buffer, ref int pos);
        void ParsePropValue(byte[] buffer, ref int pos);
    }


    public abstract class ElementTypeProcessBase
    {
        protected readonly IPropertyProcess _process;
        protected ElementTypeProcessBase(IPropertyProcess process)
        {
            _process = process;
        }

        protected abstract void Parse(byte[] buffer, ref int pos);

        class MarkerProcess:ElementTypeProcessBase
        {
            public MarkerProcess(IPropertyProcess process) : base(process) { }
            protected override void Parse(byte[] buffer, ref int pos)
            {
                _process.ParseMarker(buffer, ref pos);
            }
        }
        class MetaPropertyProcess : ElementTypeProcessBase
        { 
            public MetaPropertyProcess(IPropertyProcess process) : base(process) { }

            protected override void Parse(byte[] buffer, ref int pos)
            {
                _process.ParseMetaProperty(buffer, ref pos);
            }
        }
        class PropValueProcess : ElementTypeProcessBase
        {
            public PropValueProcess(IPropertyProcess process) : base(process) { }

            protected override void Parse(byte[] buffer, ref int pos)
            {
                _process.ParsePropValue(buffer, ref pos);
            }
        }

        public static void ParseByElementType(byte[] buffer, ref int pos, IPropertyProcess process)
        {
            var property = (UInt32)ParseSerialize.ParseInt32(buffer, pos);
            ElementTypeProcessBase elementTypeProcess = null;
            if (MetaProperty.JudgePropIsMetaProp(property))
            {
                elementTypeProcess = new MetaPropertyProcess(process);
            }
            else if (Marker.JudgeIsMarker(property))
            {
                elementTypeProcess = new MarkerProcess(process);
            }
            else
            {
                elementTypeProcess = new PropValueProcess(process);
            }
            elementTypeProcess.Parse(buffer, ref pos);
        }
    }

    
}
