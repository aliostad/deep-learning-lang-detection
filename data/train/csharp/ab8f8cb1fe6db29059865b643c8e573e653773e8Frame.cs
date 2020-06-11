/*
* SXZ Reference Implementation
*
* Copyright (c) 2014, Dark Lilac. All rights reserved.
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
* MA 02110-1301 USA
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library
{
    /// <summary>
    /// Holds a single still image of data consisting of multiple Chunks of data.  Responsible for output of it's children chunks and parsing itself and it's children.
    /// </summary>
    public class Frame
    {
        public Frame()
        {
            Chunks = new List<Chunk>();
        }

        public static string Label { get { return "FR"; } }

        public List<Chunk> Chunks { get; private set; }

        public Chunk GetSelected(int x, int y)
        {
            for (int i = this.Chunks.Count - 1; i >= 0; i--)
            {
                Chunk chunk = this.Chunks[i];
                if (chunk.IsPalette())
                {
                    continue;
                }

                if (chunk.IsBackground())
                {
                    continue;
                }

                SxzPoint boundingBox = new SxzPoint(0, 0);
                SxzPoint origin = chunk.Origin;
                chunk.EnsureDimensions(boundingBox);
                if (x >= origin.X && y >= origin.Y && x < (boundingBox.X) && y < (boundingBox.Y))
                {
                    if (chunk.GetColor(x, y) != null)
                    {
                        return chunk;
                    }
                }
            }

            return null;
        }

        public byte[] GetData()
        {
            List<byte> result = new List<byte>();
            byte[] byteLabel = Encoding.ASCII.GetBytes(Label);
            Writer.AddBytes(result, byteLabel);

            foreach (Chunk chunk in Chunks)
            {
                result.AddRange(chunk.GetData());
            }

            //don't forget the size
            Writer.WriteSizeInt(result);

            return result.ToArray();
        }

        public void SetData(byte[] data)
        {
            //skip label and size
            int index = 0;
            PaletteChunk paletteChunk = new DefaultPaletteChunk();
            while (index < data.Length)
            {
                string label = Encoding.ASCII.GetString(data, index, 2);

                //case statement would work better here
                if (label.Equals(ColorBitPlaneChunk.Label))
                {
                  int size = BitConverter.ToInt16(data, index + 2);
                  byte[] chunkData = new byte[size + 4];
                  Array.Copy(data, index, chunkData, 0, chunkData.Length);
                  ColorBitPlaneChunk colorChunk = new ColorBitPlaneChunk();
                  colorChunk.Palette = paletteChunk;
                  colorChunk.SetData(chunkData);
                  Chunks.Add(colorChunk);
                  index += size + 4;
                }
                else if (label.Equals(ColorRectangleChunk.Label))
                {
                    int size = BitConverter.ToInt16(data, index + 2);
                    byte[] chunkData = new byte[size + 4];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    ColorRectangleChunk colorRectangleChunk = new ColorRectangleChunk();
                    colorRectangleChunk.Palette = paletteChunk;
                    colorRectangleChunk.SetData(chunkData);
                    Chunks.Add(colorRectangleChunk);
                    index += size + 4;
                }
                else if (label.Equals(MonoBitPlaneChunk.Label))
                {
                    int size = BitConverter.ToInt16(data, index + 2);
                    byte[] chunkData = new byte[size + 4];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    MonoBitPlaneChunk monoChunk = new MonoBitPlaneChunk();
                    monoChunk.Palette = paletteChunk;
                    monoChunk.SetData(chunkData);
                    Chunks.Add(monoChunk);
                    index += size + 4;
                }
                else if (label.Equals(TransparentBitPlaneChunk.Label))
                {
                    int size = BitConverter.ToInt16(data, index + 2);
                    byte[] chunkData = new byte[size + 4];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    TransparentBitPlaneChunk transparentChunk = new TransparentBitPlaneChunk();
                    transparentChunk.SetData(chunkData);
                    Chunks.Add(transparentChunk);
                    index += size + 4;
                }
                else if (label.Equals(MonoRectangleChunk.Label))
                {
                    //must be background
                    MonoRectangleChunk chunk = new MonoRectangleChunk();
                    byte[] chunkData = new byte[11];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    chunk.Palette = paletteChunk;
                    chunk.SetData(chunkData);
                    Chunks.Add(chunk);
                    index += chunkData.Length;
                }
                else if (label.Equals(TransparentRectangleChunk.Label))
                {
                    //must be background
                    TransparentRectangleChunk chunk = new TransparentRectangleChunk();
                    byte[] chunkData = new byte[10];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    chunk.SetData(chunkData);
                    Chunks.Add(chunk);
                    index += chunkData.Length;
                }
                else if (label.Equals(PaletteChunk.Label))
                {
                    //must be background
                    PaletteChunk chunk = new PaletteChunk();
                    int count = (data[index + 2] + 1) * 3;
                    byte[] chunkData = new byte[count + 3];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    chunk.SetData(chunkData);
                    Chunks.Add(chunk);
                    index += chunkData.Length;
                    paletteChunk = chunk;
                }
                else if (label.Equals(DefaultPaletteChunk.Label))
                {
                    //must be background
                    DefaultPaletteChunk chunk = new DefaultPaletteChunk();
                    int count = (data[index + 2] + 1) * 3;
                    byte[] chunkData = new byte[count + 3];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    chunk.SetData(chunkData);
                    Chunks.Add(chunk);
                    index += chunkData.Length;
                    paletteChunk = chunk;
                }
                else if (label.Equals(GrayBitPlaneChunk.Label))
                {
                    int size = BitConverter.ToInt16(data, index + 2);
                    byte[] chunkData = new byte[size + 4];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    GrayBitPlaneChunk chunk = new GrayBitPlaneChunk();
                    chunk.SetData(chunkData);
                    Chunks.Add(chunk);
                    index += size + 4;
                }
                else if (label.Equals(BlackWhiteBitPlaneChunk.Label))
                {
                    int size = BitConverter.ToInt16(data, index + 2);
                    byte[] chunkData = new byte[size + 4];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    BlackWhiteBitPlaneChunk chunk = new BlackWhiteBitPlaneChunk();
                    chunk.SetData(chunkData);
                    Chunks.Add(chunk);
                    index += size + 4;
                }
                else if (label.Equals(BackgroundChunk.Label))
                {
                    //Console.WriteLine("default to background with label " + label);
                    //must be background
                    BackgroundChunk background = new BackgroundChunk();
                    background.Palette = paletteChunk;
                    byte[] chunkData = new byte[3];
                    Array.Copy(data, index, chunkData, 0, chunkData.Length);
                    background.SetData(chunkData);
                    Chunks.Add(background);
                    index += chunkData.Length;
                }
                else
                {
                    Console.WriteLine("Invalid chunk label " + label);
                    Console.WriteLine("At " + index + " " + Chunks.Count);
                    if (Chunks.Last() != null)
                    {
                        Console.WriteLine("Last chunk was " + Chunks.Last().Origin.ToString());
                    }

                    return;
                }
            }
        }

        public void EnsureDimensions(SxzPoint boundingBox)
        {
            foreach (Chunk chunk in Chunks)
            {
                chunk.EnsureDimensions(boundingBox);
            }
        }

        /// <summary>
        /// Want the number of bytes it takes to store size of bits
        /// </summary>
        /// <param name="size"></param>
        /// <returns></returns>
        public static int SizeOfBitPlaneInBytes(int size)
        {
            int divisor = (int)(size / 8);
            if (size % 8 == 0)
            {
                return divisor;
            }

            return divisor + 1;
        }
    }
}
