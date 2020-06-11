using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNGHandler
{
   /// <summary>
   /// A class to represent a chunk of PNG data.
   /// </summary>
   class PNG_Chunk
   {
      public PNG_Chunk(byte[] chunk_data, ref int byte_index)
      {
         if (chunk_data == null)
         {
            throw new System.ArgumentNullException();
         }
         if (byte_index >= chunk_data.Length
            || chunk_data.Length - byte_index < 12)
         {
            throw new System.ArgumentException("PNG_Chunk: Passed invalid byte_index.");
         }
         else if (chunk_data.Length < 12)
         {
            throw new System.ArgumentException("PNG_Chunk: Invalid chunk data passed.");
         }

         // gather chunk data
         // 1) 4 bytes: length of chunk data
         chunk_length_p = (int)chunk_data[byte_index++];
         for (int i = 1; i < 4; i++)
         {
            chunk_length_p = chunk_length_p << 8;
            chunk_length_p += (int)chunk_data[byte_index++];
         }

         // 2) 4 bytes: chunk name
          System.Text.StringBuilder sb = new System.Text.StringBuilder();
         for (int i = 0; i < 4; i++)
         {
            sb.Append((char)chunk_data[byte_index++]);
         }
         chunk_name_p = sb.ToString();

         // 3) Variable length: chunk data
         chunk_data_p = new byte[chunk_length_p];
         for (int i = 0; i < chunk_length_p; i++)
         {
            chunk_data_p[i] = chunk_data[byte_index++];
         }
         // chunk_data.CopyTo(chunk_data_p, 0);
         //byte_index += chunk_length_p;

         // 4) 4 bytes: CRC
         chunk_CRC_p = new byte[4];
         for (int i = 0; i < 4; i++)
         {
            chunk_CRC_p[i] = chunk_data[byte_index++];
         }
      }

      /// <summary>
      /// Construct a PNG data chunk from a string of bytes. The string is truncated by the amount of a chunk and passed back.
      /// </summary>
      /// <param name="chunk_data">The long string of bytes that comes from the meat of a PNG file, AFTER the PNG header.</param>
      public PNG_Chunk(ref string chunk_data)
      {
         if (chunk_data.IndexOf("PNG") == 1)
         {
            // truncate out the header of the PNG file
            chunk_data = chunk_data.Substring(8);
         }
         if (chunk_data.Length < 12)
         {
            throw new Exception("PNG chunk wasn't passed valid data.");
         }

         // get the chunk's name
         string chunk_length_str = chunk_data.Substring(0, 4);
         chunk_name_p = chunk_data.Substring(4, 4);
         // get the chunk's data length (in # of bytes)
         chunk_length_p = interpret_chunk_length_string(chunk_length_str);
         // get the chunk's actual data
         string chunk_data_str = chunk_data.Substring(8, chunk_length);
         datastream_p = chunk_data_str;
         chunk_data_p = str_to_byte_arr(chunk_data_str);
         // get the chunk's CRC
         string chunk_CRC_str = chunk_data.Substring(8 + chunk_length, 4);
         chunk_CRC_p = str_to_byte_arr(chunk_CRC_str);

         // alter passed-in string to truncate by the amount of data parsed for this chunk
         chunk_data = chunk_data.Substring(12 + chunk_length);
      }

      /// <summary>
      /// Convert the data required to construct a chunk of data for a PNG file into a PNG chunk representative.
      /// </summary>
      /// <param name="chunk_length">The number of bytes in the data section of the chunk.</param>
      /// <param name="chunk_name">The header name of the chunk</param>
      /// <param name="chunk_data">The array of bytes that comprise the data section of the PNG chunk.</param>
      /// <param name="chunk_CRC">The CRC to place at the end of the chunk.</param>
      public PNG_Chunk(uint chunk_length, string chunk_name, byte[] chunk_data, byte[] chunk_CRC)
      {
         if(chunk_data.Equals(null)
            && chunk_length != 0)
         {
            throw new ArgumentException("PNG Chunk wasn't passed valid chunk data.");
         }
         else if(chunk_name.Length != 4
            || chunk_CRC.Length != 4)
         {
            throw new ArgumentException("PNG Chunk wasn't passed valid data.");
         }

         this.chunk_length_p = (int)chunk_length;
         this.chunk_name_p = chunk_name;
         this.chunk_data_p = chunk_data;
         this.chunk_CRC_p = chunk_CRC;
         // read the property bits
         this.is_ancillary_p = (1 << 5 & (byte)chunk_name[0]) > 0;
         this.is_private_p = (1 << 5 & (byte)chunk_name[1]) > 0;
         this.is_safe_to_copy_p = (1 << 5 & (byte)chunk_name[3]) > 0;
      }

      private byte[] str_to_byte_arr(string chunk_data_str){
         if (chunk_data_str.Equals(null))
         {
            return null;
         }

         byte[] result = new byte[chunk_data_str.Length];

         for (int i = 0; i < chunk_data_str.Length; i++)
         {
            result[i] = (byte)chunk_data_str[i];
         }

         return result;
      }

      public int interpret_chunk_length_string(string chunk_length_str)
      {
         if (chunk_length_str.Length != 4)
         {
            return -1;
         }

         int length = 0;

         // presuming the length is really just the bytes interpreted to an int...
         // check for whether the data is in big-endian format, which i assume it is
         length = (int)chunk_length_str[0];
         for (int i = 1; i < 4; i++)
         {
            length = length << 8;
            length += (int)chunk_length_str[i];
         }

         return length;
      }

      public bool is_IEND()
      {
         if (chunk_name.Equals("IEND"))
         {
            return true;
         }
         else
         {
            return false;
         }
      }

      override public string ToString()
      {
         StringBuilder readable_chunk = new StringBuilder();

         readable_chunk.Append(String.Format("Chunk name: {0}\n", chunk_name));
         readable_chunk.Append(String.Format("\tChunk length: {0}\n", chunk_length));
         if (chunk_data.Length > 0)
         {
            readable_chunk.Append(String.Format("\tChunk data: (0){0}", chunk_data[0]));
            for (int i = 1; i < chunk_data.Length; i++)
            {
               readable_chunk.Append(String.Format(", ({0}){1}", i, chunk_data[i]));
            }
            readable_chunk.Append("\n");
         }
         else
         {
            readable_chunk.Append(String.Format("\tChunk data: N\\A\n"));
         }
         readable_chunk.Append(String.Format("\t\t(Chunk data length: {0})\n", chunk_data.Length));
         if (chunk_CRC.Length > 0)
         {
            readable_chunk.Append(String.Format("\tChunk CRC: (0){0}", chunk_CRC[0]));
            for (int i = 1; i < chunk_CRC.Length; i++)
            {
               readable_chunk.Append(String.Format(", ({0}){1}", i, chunk_CRC[i]));
            }
            readable_chunk.Append("\n");
         }
         else
         {
            readable_chunk.Append(String.Format("\tChunk CRC: N\\A\n"));
         }
         // readable_chunk.Append(String.Format("\tChunk CRC: {0}\n", chunk_CRC));

         return readable_chunk.ToString();
      }

      // Fields
      private string chunk_name_p;
      private int chunk_length_p;
      private byte[] chunk_data_p;
      private string datastream_p;
      //private string chunk_data_p;
      private byte[] chunk_CRC_p;

      // Property Bit Values
      private bool is_ancillary_p;
      private bool is_private_p;
      private bool is_safe_to_copy_p;

      // Properties
      public string chunk_name
      {
         get { return chunk_name_p; }
      }
      public int chunk_length {
         get{ return chunk_length_p; }
      }
      public byte[] chunk_data{
         get { return chunk_data_p; }
      }
      public string datastream
      {
         get { return datastream_p; }
      }
      public byte[] chunk_CRC{
         get { return chunk_CRC_p; }
      }
      public bool is_ancillary
      {
         get { return is_ancillary_p; }
      }
      public bool is_private
      {
         get { return is_private_p; }
      }
      public bool is_safe_to_copy
      {
         get { return is_safe_to_copy_p; }
      }
   }
}
