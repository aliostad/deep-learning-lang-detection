using System;
using System.Windows.Forms;

namespace Screens.Instruments
{
    public class CursorFactory
    {
        public static Cursor Create(InstrumentType type)
        {
            switch (type)
            {
                case InstrumentType.Blur:
                case InstrumentType.Eraser:
                    return Resources.Cursors.EraserToolCursor;
                case InstrumentType.Pen:
                    return Resources.Cursors.PencilToolCursor;
                case InstrumentType.Rect:
                    return Resources.Cursors.RectangleToolCursor;
                //todo: 
                //case InstrumentType.Line:
                //case InstrumentType.Arrow:
                //case InstrumentType.Hightlight:
                //case InstrumentType.Text:
                default:
                    return Resources.Cursors.GenericToolCursor;
            }
        }
    }
}