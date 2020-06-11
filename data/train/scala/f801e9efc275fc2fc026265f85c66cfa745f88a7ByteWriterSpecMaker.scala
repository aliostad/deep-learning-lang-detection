/*  ___ _  ___ _ _                                                            *\
** / __| |/ (_) | |       The SKilL Generator                                 **
** \__ \ ' <| | | |__     (c) 2013 University of Stuttgart                    **
** |___/_|\_\_|_|____|    see LICENSE                                         **
\*                                                                            */
package de.ust.skill.generator.ada.internal

import de.ust.skill.generator.ada.GeneralOutputMaker

trait ByteWriterSpecMaker extends GeneralOutputMaker {
  abstract override def make {
    super.make
    val out = open(s"""${packagePrefix}-api-internal-byte_writer.ads""")

    out.write(s"""
with Ada.Unchecked_Conversion;

--
--  This package provides the procedures to write the basic skill types into a
--  given stream.
--

private package ${packagePrefix.capitalize}.Api.Internal.Byte_Writer is

   --  Writes the buffer into the stream and resets the buffer.
   procedure Finalize_Buffer (Stream : ASS_IO.Stream_Access);

   procedure Write_i8 (
      Stream : ASS_IO.Stream_Access;
      Value  : i8
   );
   procedure Write_i16 (
      Stream : ASS_IO.Stream_Access;
      Value  : i16
   );
   procedure Write_i32 (
      Stream : ASS_IO.Stream_Access;
      Value  : i32
   );
   procedure Write_i64 (
      Stream : ASS_IO.Stream_Access;
      Value  : i64
   );

   procedure Write_v64 (
      Stream : ASS_IO.Stream_Access;
      Value  : v64
   );

   procedure Write_f32 (
      Stream : ASS_IO.Stream_Access;
      Value  : f32
   );
   procedure Write_f64 (
      Stream : ASS_IO.Stream_Access;
      Value  : f64
   );

   procedure Write_Boolean (
      Stream : ASS_IO.Stream_Access;
      Value  : Boolean
   );
   procedure Write_String (
      Stream : ASS_IO.Stream_Access;
      Value  : String
   );

private

   Buffer_Size  : constant Positive := 2 ** 12;
   Buffer_Index :          Natural  := 0;
   type Buffer is array (Positive range <>) of Byte;
   procedure Write_Buffer (
      Stream : not null access Ada.Streams.Root_Stream_Type'Class;
      Item   : in Buffer
   );
   for Buffer'Write use Write_Buffer;
   Buffer_Array : Buffer (1 .. Buffer_Size);

   procedure Write_Byte (
      Stream : ASS_IO.Stream_Access;
      Next   : Byte
   );

   pragma Inline (
      Finalize_Buffer,
      Write_i8,
      Write_i16,
      Write_i32,
      Write_i64,
      Write_v64,
      Write_f32,
      Write_f64,
      Write_Boolean,
      Write_String,
      Write_Buffer,
      Write_Byte
   );

end ${packagePrefix.capitalize}.Api.Internal.Byte_Writer;
""")

    out.close()
  }
}
