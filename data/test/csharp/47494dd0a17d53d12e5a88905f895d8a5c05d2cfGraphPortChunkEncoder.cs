using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;

using NewTOAPIA;
using NewTOAPIA.Net;
using NewTOAPIA.Drawing;

using TOAPI.GDI32;
using TOAPI.Types;

namespace HumLog
{
    public class GraphPortChunkEncoder : GraphPortDelegate
    {
        public delegate void ChunkPacked(BufferChunk chunk);

        public event ChunkPacked ChunkPackedEvent;


        IntPtr fDeviceContext;

        public GraphPortChunkEncoder()
        {
            fDeviceContext = IntPtr.Zero;
        }

        public IntPtr DeviceContext
        {
            get
            {
                return fDeviceContext;
            }
        }

        void PackCommand(BufferChunk aCommand)
        {
            if (ChunkPackedEvent != null)
                ChunkPackedEvent(aCommand);
        }

        void PackCommand(EMR aCommand)
        {
            BinaryFormatter fFormatter = new BinaryFormatter();
            MemoryStream fMemoryStream = new MemoryStream(2048);
            fMemoryStream.Seek(0, SeekOrigin.Begin);

            fFormatter.Serialize(fMemoryStream, aCommand);

            byte[] sendBytes = fMemoryStream.GetBuffer();


            BufferChunk chunk = new BufferChunk(sendBytes);
            //PackCommand(chunk);
        }

        void Pack(BufferChunk aChunk, int x, int y)
        {
            aChunk += x;
            aChunk += y;
        }

        void Pack(BufferChunk aChunk, Rectangle rect)
        {
            aChunk += (int)rect.Left;
            aChunk += (int)rect.Top;
            aChunk += (int)rect.Width;
            aChunk += (int)rect.Height;
        }

        void Pack(BufferChunk aChunk, int left, int top, int right, int bottom)
        {
            aChunk += left;
            aChunk += top;
            aChunk += right;
            aChunk += bottom;
        }

        void Pack(BufferChunk chunk, Point[] points)
        {
            // Need to know how many points so that space can be allocated for them on the receiving end
            chunk += points.Length;

            // Encode each of the points
            for (int i = 0; i < points.Length; i++)
            {
                Pack(chunk, points[i].x, points[i].y);
            }
        }

        void Pack(BufferChunk chunk, Guid uniqueID)
        {
            //chunk += uniqueID.ToString();
            chunk += (int)16; // For size of the following array
            chunk += uniqueID.ToByteArray();
        }

        void Pack(BufferChunk chunk, XFORM aTrans)
        {
            //chunk += aTrans.eDx;
            //chunk += aTrans.eDy;
            //chunk += aTrans.eM11;
            //chunk += aTrans.eM12;
            //chunk += aTrans.eM21;
            //chunk += aTrans.eM22;
        }

        void Pack(BufferChunk chunk, TRIVERTEX[] vertices)
        {
            int nVertices = vertices.Length;

            // Pack the vertices, starting with the length
            chunk += nVertices;
            for (int i = 0; i < nVertices; i++)
            {
                chunk += vertices[i].x;
                chunk += vertices[i].y;
                chunk += vertices[i].Alpha;
                chunk += vertices[i].Blue;
                chunk += vertices[i].Green;
                chunk += vertices[i].Red;
            }
        }

        void Pack(BufferChunk chunk, GRADIENT_RECT[] gRect)
        {
            int nRects = gRect.Length;

            chunk += nRects;
            for (int i = 0; i < nRects; i++)
            {
                chunk += gRect[i].UpperLeft;
                chunk += gRect[i].LowerRight;
            }
        }

        // Modes and attributes
        public override void SetTextColor(uint colorref)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETTEXTCOLOR;
            chunk += colorref;

            PackCommand(chunk);
        }

        // Various drawing commands
        //public override void MoveTo(int x, int y)
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_MOVETOEX;
        //    chunk += x;
        //    chunk += y;

        //    PackCommand(chunk);
        //}


        //public override void LineTo(int x, int y)
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_LINETO;
        //    chunk += x;
        //    chunk += y;

        //    PackCommand(chunk);
        //}



        /// Some GraphPort control things
        /// 
        public override void SaveState()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SAVEDC;

            PackCommand(chunk);
        }

        /// <summary>
        /// Pop all the current state information back to the defaults
        /// </summary>
        public override void ResetState()
        {
            RestoreState(-1);
        }

        public override void RestoreState(int relative)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_RESTOREDC;
            chunk += relative;

            PackCommand(chunk);
        }

        public override void Flush()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_EOF;

            PackCommand(chunk);
        }

        public override void SetROP2(BinaryRasterOps rasOp)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETROP2;
            chunk += (Int32)rasOp;

            PackCommand(chunk);
        }

        // Drawing Primitives
        /// Our first pass will be to implement everything as 
        /// taking explicit int parameters.
        /// We'll assume that drawing with a different pen will 
        /// be accomplished by setting the Pen property on the 
        /// port before drawing.  This will keep our API count 
        /// low and alleviate the need to pass the same 
        /// parameter every time.  We can add more later.
        ///
        public override void SetPixel(int x, int y, Color colorref)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETTEXTCOLOR;
            Pack(chunk, x, y);
            chunk += colorref.ToArgb();

            PackCommand(chunk);
        }

        //public override void UseDefaultBrush()
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_SELECTSTOCKOBJECT;
        //    chunk += GDI32.DC_BRUSH;

        //    PackCommand(chunk);
        //}

        //public override void SetDefaultPenColor(uint colorref)
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_SETDCPENCOLOR;
        //    chunk += colorref;

        //    PackCommand(chunk);
        //}

        public override void SetPen(GPen aPen)
        {
            SelectUniqueObject(aPen.UniqueID);
        }

        //public override void UseDefaultPen()
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_SELECTSTOCKOBJECT;
        //    chunk += GDI32.DC_PEN;

        //    PackCommand(chunk);
        //}

        //public override void SetDefaultBrushColor(uint colorref)
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_SETDCBRUSHCOLOR;
        //    chunk += colorref;

        //    PackCommand(chunk);
        //}

        public override void SelectUniqueObject(Guid objectID)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SELECTUNIQUEOBJECT;
            chunk += (int)16;   // The following byte array is 16 elements long
            chunk += objectID.ToByteArray();

            PackCommand(chunk);
        }

        //public override void SelectStockObject(int objIndex)
        //{
        //    BufferChunk chunk = new BufferChunk(128);
        //    chunk += GDI32.EMR_SELECTSTOCKOBJECT;
        //    chunk += objIndex;

        //    PackCommand(chunk);
        //}

        void SelectObject(IHandle aObject)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SELECTOBJECT;
            chunk += aObject.Handle.ToInt32();

            PackCommand(chunk);
        }

        public override void DrawRoundRect(GPen aPen, Rectangle rect)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_ROUNDRECT;
            Pack(chunk, rect);
            Pack(chunk, width, height);

            PackCommand(chunk);
        }

        public override void DrawRectangle(GPen aPen, Rectangle rect)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_RECTANGLE;
            Pack(chunk, rect);

            PackCommand(chunk);
        }

        // Gradient Fills
        public override void DrawGradientRectangle(GradientRect gRect)
        {
            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_GRADIENTFILL;

            // Pack the vertices
            Pack(chunk, gRect.Vertices);

            // Pack the gradient mesh
            Pack(chunk, gRect.Boundary);

            // pack the mode
            chunk += (int)gRect.Direction;

            PackCommand(chunk);
        }

        //public override void GradientTriangle(TRIVERTEX[] pVertex, GRADIENT_TRIANGLE[] pMesh, uint dwMode)
        //{
        //    EMRGRADIENTFILL gradFill = new EMRGRADIENTFILL();
        //    gradFill.rclBounds = RECT.Empty;
        //    gradFill.nVer = (uint)pVertex.Length;
        //    gradFill.nTri = (uint)pMesh.Length;
        //    gradFill.ulMode = dwMode;
        //    gradFill.Ver = pVertex;

        //    PackCommand(gradFill);
        //}

        /// DrawEllipse
        /// 
        public override void DrawEllipse(GPen aPen, Rectangle rect)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_ELLIPSE;
            Pack(chunk, rect);

            PackCommand(chunk);
        }


        public override void DrawString(int x, int y, string aString)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_EXTTEXTOUTW;
            Pack(chunk, x, y);
            chunk += aString.Length;
            chunk += aString;
            //chunk += GDI32.GM_ADVANCED;

            PackCommand(chunk);
        }

        public virtual void MeasureCharacter(char c, ref int width, ref int height)
        {
            int[] aBuffer = new int[1];

            if (GDI32.GetCharWidth32(DeviceContext, (uint)c, (uint)c, out aBuffer))
                width = aBuffer[0];
            else
                width = 0;

            //MeasureString(new string(c,1), ref width, ref height);
        }

        public override void PolyBezier(Point[] points)
        {
            BufferChunk chunk = new BufferChunk(points.Length * 8 + 16);
            chunk += GDI32.EMR_POLYBEZIER;

            Pack(chunk, points);

            PackCommand(chunk);
        }

        public override void DrawLines(GPen aPen, Point[] points)
        {
            BufferChunk chunk = new BufferChunk(points.Length * 8 + 16);
            chunk += GDI32.EMR_POLYLINE;

            Pack(chunk, points);

            PackCommand(chunk);
        }

        public override void PolyDraw(Point[] points, byte[] ptMeanings)
        {
            BufferChunk chunk = new BufferChunk(points.Length * 8 + 16);
            chunk += GDI32.EMR_POLYDRAW;

            Pack(chunk, points);


            for (int i = 0; i < points.Length; i++)
                chunk += ptMeanings[i];

            PackCommand(chunk);
        }

        // Draw a Polygon
        public override void Polygon(Point[] points)
        {
            BufferChunk chunk = new BufferChunk(points.Length * 8 + 16);
            chunk += GDI32.EMR_POLYGON;

            Pack(chunk, points);

            PackCommand(chunk);
        }



        // Generalized bit block transfer

        // Can transfer from any device context to this one.
        public override void BitBlt(int x, int y, PixelBuffer pixBuff)
        {
            // Create a buffer
            // It has to be big enough for the bitmap data, as well as the x,y, and command
            int dataSize = pixBuff.Pixels.Stride * pixBuff.Pixels.Height;
            BufferChunk chunk = new BufferChunk(dataSize + 128);

            // now put the basic command and simple components in
            chunk += GDI32.EMR_BITBLT;
            Pack(chunk, x, y);
            Pack(chunk, pixBuff.Pixels.Width, pixBuff.Pixels.Height);
            chunk += dataSize;

            // Finally, copy in the data
            chunk.CopyFrom(pixBuff.Pixels.Data, dataSize);

            PackCommand(chunk);
        }

        public override void AlphaBlend(int x, int y, int width, int height,
                PixelBuffer pixBuff, int srcX, int srcY, int srcWidth, int srcHeight,
                byte alpha)
        {
            // Create a buffer
            // It has to be big enough for the bitmap data, as well as the x,y, and command
            int dataSize = pixBuff.Pixels.Stride * pixBuff.Pixels.Height;
            BufferChunk chunk = new BufferChunk(dataSize + 128);

            // now put the basic command and simple components in
            chunk += GDI32.EMR_ALPHABLEND;
            Pack(chunk, x, y, width, height);
            Pack(chunk, srcX, srcY, srcWidth, srcHeight);
            chunk += alpha;

            Pack(chunk, pixBuff.Pixels.Width, pixBuff.Pixels.Height);
            chunk += dataSize;

            // Finally, copy in the data
            chunk.CopyFrom(pixBuff.Pixels.Data, dataSize);

            PackCommand(chunk);

        }

        public override void ScaleBitmap(PixelBuffer aBitmap, RECT aFrame)
        {
            AlphaBlend(aFrame.Left, aFrame.Top, aFrame.Width, aFrame.Height,
                aBitmap, 0, 0, aBitmap.Width, aBitmap.Height, aBitmap.Alpha);
        }

        // Dealing with a path
        public override void BeginPath()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_BEGINPATH;

            PackCommand(chunk);
        }

        public override void EndPath()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_ENDPATH;

            PackCommand(chunk);
        }

        public override void FramePath()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_STROKEPATH;

            PackCommand(chunk);
        }

        public override void FillPath()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_FILLPATH;

            PackCommand(chunk);
        }

        public override void DrawPath()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_STROKEANDFILLPATH;

            PackCommand(chunk);
        }

        public override void SetPathAsClipRegion()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SELECTCLIPPATH;
            chunk += (int)RegionCombineStyles.RGN_COPY;

            PackCommand(chunk);
        }

        public override void SetMappingMode(MappingModes aMode)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETMAPMODE;
            chunk += (int)aMode;

            PackCommand(chunk);
        }

        public override void SetBkColor(uint colorref)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETBKCOLOR;
            chunk += colorref;

            PackCommand(chunk);
        }

        public override void SetBkMode(int bkMode)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETBKMODE;
            chunk += bkMode;

            PackCommand(chunk);
        }

        public override void SetPolyFillMode(int aMode)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETPOLYFILLMODE;
            chunk += aMode;

            PackCommand(chunk);
        }

        // ViewPort Calls
        public override void SetViewportOrigin(int x, int y)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETVIEWPORTORGEX;
            Pack(chunk, x, y);

            PackCommand(chunk);
        }

        public override void SetViewportExtent(int width, int height)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETVIEWPORTEXTEX;
            Pack(chunk, width, height);

            PackCommand(chunk);
        }


        // Window calls
        public override void SetWindowOrigin(int x, int y)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETWINDOWORGEX;
            Pack(chunk, x, y);

            PackCommand(chunk);
        }

        public override void SetWindowExtent(int width, int height)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETWINDOWEXTEX;
            Pack(chunk, width, height);

            PackCommand(chunk);
        }

        //public XFORM WorldTransform
        //{
        //    get { return GetWorldTransform(); }

        //    set { SetWorldTransform(value); }
        //}

        //private XFORM GetWorldTransform()
        //{
        //    XFORM aTransform = new XFORM();
        //    bool result = GDI32.GetWorldTransform(DeviceContext, out aTransform);

        //    return aTransform;
        //}

        public override void SetWorldTransform(XFORM aTransform)
        {
            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_SETWORLDTRANSFORM;
            Pack(chunk, aTransform);

            PackCommand(chunk);
        }

        public override void CreateFont(string faceName, int height, Guid uniqueID)
        {
            Font newFont = new GDIFont(faceName, height, uniqueID);

            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_EXTCREATEFONTINDIRECTW;

            chunk += faceName.Length;
            chunk += faceName;
            chunk += (int)height;
            chunk += (byte)1; // newFont.fLogFont.lfCharSet;
            chunk += (byte)0; // newFont.fLogFont.lfClipPrecision;
            chunk += (int)0; // newFont.fLogFont.lfEscapement;
            chunk += (byte)0; // newFont.fLogFont.lfItalic;
            chunk += (int)0; // newFont.fLogFont.lfOrientation;
            chunk += (byte)0; // newFont.fLogFont.lfOutPrecision;
            chunk += (byte)0; // newFont.fLogFont.lfPitchAndFamily;
            chunk += (byte)0; // newFont.fLogFont.lfQuality;
            chunk += (byte)0; // newFont.fLogFont.lfStrikeOut;
            chunk += (byte)0; // newFont.fLogFont.lfUnderline;
            chunk += (int)0; // newFont.fLogFont.lfWeight;
            chunk += (int)0; // newFont.fLogFont.lfWidth;

            // Write the GUID
            chunk += (int)16; // For size of the following array
            chunk += newFont.UniqueID.ToByteArray();

            PackCommand(chunk);

        }

        public override void CreateBrush(int aStyle, int hatch, uint color, Guid uniqueID)
        {
            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_CREATEBRUSHINDIRECT;
            chunk += aStyle;
            chunk += hatch;
            chunk += color;
            Pack(chunk, uniqueID);

            PackCommand(chunk);
        }

        public override void CreateCosmeticPen(PenStyle aStyle, uint color, Guid uniqueID)
        {
            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_CREATECOSMETICPEN;
            chunk += (int)aStyle;
            chunk += (int)1;    // Width
            chunk += color;
            Pack(chunk, uniqueID);

            PackCommand(chunk);
        }
    }
}