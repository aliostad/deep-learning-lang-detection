using System;
using System.Drawing;
using System.Collections.Generic;

using TOAPI.Types;
using TOAPI.GDI32;

using NewTOAPIA;
using NewTOAPIA.Drawing;
using NewTOAPIA.Drawing.GDI;

namespace PixelShare.Core
{
    public static class ChunkUtils
    {
        #region Packing Methods
        public static void Pack(BufferChunk aChunk, int x, int y)
        {
            aChunk += x;
            aChunk += y;
        }

        public static void Pack(BufferChunk aChunk, int left, int top, int right, int bottom)
        {
            aChunk += left;
            aChunk += top;
            aChunk += right;
            aChunk += bottom;
        }

        public static void Pack(BufferChunk chunk, Point aPoint)
        {
            chunk += aPoint.X;
            chunk += aPoint.Y;
        }

        public static void Pack(BufferChunk chunk, Point[] points)
        {
            // Need to know how many points so that space can be allocated for them on the receiving end
            chunk += points.Length;

            // Encode each of the points
            for (int i = 0; i < points.Length; i++)
            {
                Pack(chunk, points[i].X, points[i].Y);
            }
        }

        public static void Pack(BufferChunk chunk, Guid uniqueID)
        {
            //chunk += uniqueID.ToString();
            chunk += (int)16; // For size of the following array
            chunk += uniqueID.ToByteArray();
        }

        public static void Pack(BufferChunk chunk, XFORM aTrans)
        {
            chunk += aTrans.eDx;
            chunk += aTrans.eDy;
            chunk += aTrans.eM11;
            chunk += aTrans.eM12;
            chunk += aTrans.eM21;
            chunk += aTrans.eM22;
        }

        public static void Pack(BufferChunk chunk, TRIVERTEX[] vertices)
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

        public static void Pack(BufferChunk chunk, GRADIENT_RECT[] gRect)
        {
            int nRects = gRect.Length;

            chunk += nRects;
            for (int i = 0; i < nRects; i++)
            {
                chunk += gRect[i].UpperLeft;
                chunk += gRect[i].LowerRight;
            }
        }

        public static void Pack(BufferChunk chunk, IBrush aBrush)
        {
            chunk += GDI32.EMR_CREATEBRUSHINDIRECT;
            chunk += (int)aBrush.BrushStyle;
            chunk += (int)aBrush.HatchStyle;
            chunk += aBrush.Color;
            Pack(chunk, aBrush.UniqueID);
        }

        public static void Pack(BufferChunk chunk, IPen aPen)
        {
            chunk += GDI32.EMR_CREATEPEN;
            chunk += (int)aPen.Style;
            chunk += 1;
            chunk += aPen.Color;
            Pack(chunk, aPen.UniqueID);
        }

        public static void Pack(BufferChunk chunk, GDIFont aFont)
        {
            chunk += GDI32.EMR_EXTCREATEFONTINDIRECTW;

            chunk += aFont.FaceName.Length;
            chunk += aFont.FaceName;
            chunk += (int)aFont.Height;
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
            Pack(chunk, aFont.UniqueID);
        }
        #endregion

        #region Unpacking routines
        public static GDIPen UnpackGPen(BufferChunk chunk)
        {
            uint penColor;
            PenStyle penStyle;
            Guid uniqueID;
            int penSize;

            penStyle = (PenStyle)chunk.NextInt32();
            penSize = chunk.NextInt32();
            penColor = chunk.NextUInt32();
            uniqueID = UnpackGuid(chunk);

            GDIPen aPen = new GDIPen(PenType.Cosmetic, PenStyle.Solid, PenJoinStyle.Round, PenEndCap.Round, penColor, penSize, uniqueID);
            return aPen;            
        }

        public static Guid UnpackGuid(BufferChunk chunk)
        {
            int bufferLength = chunk.NextInt32(); // How many bytes did we pack
            byte[] bytes = (byte[])chunk.NextBufferChunk(bufferLength);
            Guid aGuid = new Guid(bytes);

            return aGuid;
        }
        #endregion
    }
}
