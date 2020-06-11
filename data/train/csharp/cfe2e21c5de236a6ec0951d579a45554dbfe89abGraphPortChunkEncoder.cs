using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

using NewTOAPIA;
using NewTOAPIA.Net;
using NewTOAPIA.Drawing;
using NewTOAPIA.Drawing.GDI;

using TOAPI.GDI32;
using TOAPI.Types;

namespace Sketcher.Core
{
    public class GraphPortChunkEncoder : GraphPortDelegate
    {
        public delegate void ChunkEncodedHandler(BufferChunk chunk);

        public event ChunkEncodedHandler ChunkEncodedEvent;



        void SendCommand(BufferChunk aCommand)
        {
            if (ChunkEncodedEvent != null)
                ChunkEncodedEvent(aCommand);
        }

        // Modes and attributes
        public override void SetTextColor(uint colorref)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETTEXTCOLOR;
            chunk += colorref;

            SendCommand(chunk);
        }


        /// Some GraphPort control things
        /// 
        public override void SaveState()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SAVEDC;

            SendCommand(chunk);
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
            ChunkUtils.Pack(chunk, x, y);
            chunk += colorref.ToArgb();

            SendCommand(chunk);
        }


        public override void SetPen(IPen aPen)
        {
            SelectUniqueObject(aPen.UniqueID);
        }

        public override void SelectUniqueObject(Guid objectID)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SELECTUNIQUEOBJECT;
            chunk += (int)16;   // The following byte array is 16 elements long
            chunk += objectID.ToByteArray();

            SendCommand(chunk);
        }


        public override void DrawRoundRect(IPen aPen, Rectangle rect, int xRadius, int yRadius)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_ROUNDRECT;
            ChunkUtils.Pack(chunk, rect.X, rect.Y, rect.Width, rect.Height);
            ChunkUtils.Pack(chunk, xRadius, yRadius);

            ChunkUtils.Pack(chunk, aPen);

            SendCommand(chunk);
        }

        public override void DrawRectangle(IPen aPen, Rectangle rect)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_RECTANGLE;
            ChunkUtils.Pack(chunk, rect.X, rect.Y, rect.Width, rect.Height);

            ChunkUtils.Pack(chunk, aPen);

            SendCommand(chunk);
        }

        // Gradient Fills
        //public override void DrawGradientRectangle(GradientRect gRect)
        //{
        //    BufferChunk chunk = new BufferChunk(1024);
        //    chunk += GDI32.EMR_GRADIENTFILL;

        //    // Pack the vertices
        //    ChunkUtils.Pack(chunk, gRect.Vertices);

        //    // Pack the gradient mesh
        //    ChunkUtils.Pack(chunk, gRect.Boundary);

        //    // pack the mode
        //    chunk += (int)gRect.Direction;

        //    SendCommand(chunk);
        //}

        /// DrawEllipse
        /// 
        public override void DrawEllipse(IPen aPen, Rectangle rect)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_ELLIPSE;
            ChunkUtils.Pack(chunk, rect.X, rect.Y, rect.Width, rect.Height);

            SendCommand(chunk);
        }


        public override void DrawString(int x, int y, string aString)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_EXTTEXTOUTW;
            ChunkUtils.Pack(chunk, x, y);
            chunk += aString.Length;
            chunk += aString;
            //chunk += GDI32.GM_ADVANCED;

            SendCommand(chunk);
        }

        //public override void DrawBezier(GDIPen aPen, Point[] points)
        //{
        //    BufferChunk chunk = new BufferChunk(points.Length * 8 + 16);
        //    chunk += GDI32.EMR_POLYBEZIER;

        //    Pack(chunk, points);

        //    SendCommand(chunk);
        //}

        public override void DrawLine(IPen aPen, Point startPoint, Point endPoint)
        {
            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_LINETO;
            ChunkUtils.Pack(chunk, startPoint);
            ChunkUtils.Pack(chunk, endPoint);

            // Pack the pen
            ChunkUtils.Pack(chunk, aPen);

            SendCommand(chunk);
        }

        public override void DrawLines(IPen aPen, Point[] points)
        {
            BufferChunk chunk = new BufferChunk(points.Length * 8 + 128);
            chunk += GDI32.EMR_POLYLINE;

            // Pack the pen
            ChunkUtils.Pack(chunk, aPen);

            // Pack the points
            ChunkUtils.Pack(chunk, points);
            

            SendCommand(chunk);
        }

        public override void DrawPath(IPen aPen, GPath aPath)
        {
            BufferChunk chunk = new BufferChunk(aPath.Vertices.Length * 8 + 128);
            chunk += GDI32.EMR_POLYDRAW;

            ChunkUtils.Pack(chunk, aPath.Vertices);


            for (int i = 0; i < aPath.Vertices.Length; i++)
                chunk += aPath.Commands[i];

            // Pack the pen
            ChunkUtils.Pack(chunk, aPen);

            SendCommand(chunk);
        }

        // Draw a Polygon
        public override void Polygon(Point[] points)
        {
            BufferChunk chunk = new BufferChunk(points.Length * 8 + 16);
            chunk += GDI32.EMR_POLYGON;

            ChunkUtils.Pack(chunk, points);

            SendCommand(chunk);
        }


        #region Drawing Pixel Maps
        // Generalized bit block transfer
        public override void PixBlt(PixelArray pixBuff, int x, int y)
        {
            // Create a buffer
            // It has to be big enough for the bitmap data, as well as the x,y, and command
            int dataSize = pixBuff.BytesPerRow * pixBuff.Height;
            BufferChunk chunk = new BufferChunk(dataSize + 128);

            // now put the basic command and simple components in
            chunk += GDI32.EMR_BITBLT;
            ChunkUtils.Pack(chunk, x, y);
            ChunkUtils.Pack(chunk, pixBuff.Width, pixBuff.Height);
            chunk += dataSize;

            // Finally, copy in the data
            chunk.CopyFrom(pixBuff.PixelData, dataSize);

            SendCommand(chunk);
        }

        // Can transfer from any device context to this one.
        //public override void BitBlt(int x, int y, PixelBuffer pixBuff)
        //{
        //    // Create a buffer
        //    // It has to be big enough for the bitmap data, as well as the x,y, and command
        //    int dataSize = pixBuff.Stride * pixBuff.Height;
        //    BufferChunk chunk = new BufferChunk(dataSize + 128);

        //    // now put the basic command and simple components in
        //    chunk += GDI32.EMR_BITBLT;
        //    Pack(chunk, x, y);
        //    Pack(chunk, pixBuff.Width, pixBuff.Height);
        //    chunk += dataSize;

        //    // Finally, copy in the data
        //    chunk.CopyFrom(pixBuff.Pixels, dataSize);

        //    SendCommand(chunk);
        //}

        //public override void AlphaBlend(int x, int y, int width, int height,
        //        GDIPixmap pixBuff, int srcX, int srcY, int srcWidth, int srcHeight,
        //        byte alpha)
        //{
        //    // Create a buffer
        //    // It has to be big enough for the bitmap data, as well as the x,y, and command
        //    //int dataSize = pixBuff.BytesPerRow * pixBuff.Height;
        //    int dataSize = dataSize = pixBuff.Width * pixBuff.Height * ((int)pixBuff.BitCount) / 8;
        //    BufferChunk chunk = new BufferChunk(dataSize + 128);

        //    // now put the basic command and simple components in
        //    chunk += GDI32.EMR_ALPHABLEND;
        //    ChunkUtils.Pack(chunk, x, y, width, height);
        //    ChunkUtils.Pack(chunk, srcX, srcY, srcWidth, srcHeight);
        //    chunk += alpha;

        //    ChunkUtils.Pack(chunk, pixBuff.Width, pixBuff.Height);
        //    chunk += dataSize;

        //    // Finally, copy in the data
        //    chunk.CopyFrom(pixBuff.DangerousGetHandle(), dataSize);

        //    SendCommand(chunk);

        //}
        #endregion

        #region Graphport State
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

            SendCommand(chunk);
        }

        public override void Flush()
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_EOF;

            SendCommand(chunk);
        }

        public override void SetROP2(BinaryRasterOps rasOp)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETROP2;
            chunk += (Int32)rasOp;

            SendCommand(chunk);
        }

        public override void SetMappingMode(MappingModes aMode)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETMAPMODE;
            chunk += (int)aMode;

            SendCommand(chunk);
        }

        public override void SetBkColor(uint colorref)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETBKCOLOR;
            chunk += colorref;

            SendCommand(chunk);
        }

        public override void SetBkMode(int bkMode)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETBKMODE;
            chunk += bkMode;

            SendCommand(chunk);
        }

        public override void SetPolyFillMode(PolygonFillMode aMode)
        {
            BufferChunk chunk = new BufferChunk(128);
            chunk += GDI32.EMR_SETPOLYFILLMODE;
            chunk += (int)aMode;

            SendCommand(chunk);
        }

        public override void SetWorldTransform(Transformation aTransform)
        {
            BufferChunk chunk = new BufferChunk(1024);
            chunk += GDI32.EMR_SETWORLDTRANSFORM;
            //Pack(chunk, aTransform);

            SendCommand(chunk);
        }

        #endregion
    }
}