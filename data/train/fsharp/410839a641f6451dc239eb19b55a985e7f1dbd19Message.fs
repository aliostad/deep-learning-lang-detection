module ElectroElephant.Message

open ElectroElephant.Common
open ElectroElephant.CompressionNew
open ElectroElephant.Crc32
open ElectroElephant.StreamHelpers
open ElectroElephant
open System.IO

type Message = 
  { // The CRC is the CRC32 of the remainder of the message
    // bytes. This is used to check the integrity of 
    // the message on the broker and consumer.
    crc : Crc32
    // This is a version id used to allow backwards compatible evolution of the message binary format.
    magic_byte : MagicByte
    // This byte holds metadata attributes about the
    //  message. The lowest 2 bits contain the compression codec 
    // used for the message. The other bits should be set to 0.
    attributes : Compression
    // The key is an optional message key that was 
    // used for partition assignment. The key can be null.
    key : MessageKey
    // The value is the actual message contents as an opaque 
    // byte array. Kafka supports recursive messages in 
    // which case this may itself contain a 
    // message set. The message can be null.
    value : MessageValue }

type MessageSet = 
  { //This is the offset used in kafka as the log sequence number. 
    // When the producer is sending messages it doesn't actually 
    // know the offset and can fill in any value here it likes.
    offset : Offset
    messages : Message list }


/// creates a simple msg, we never compress a single message
/// because the compression rate would be very low.
let private create_simple_msg ( msg : byte [] ) : Message =
  { crc = ElectroElephant.Crc32.crc32 msg
    magic_byte = Common.MessageMagicByte
    attributes = Compression.None
    key = null
    value = msg }

/// create a simple msg and format it accordingly
/// does not compress the msg.
let create_single_msg (msg : byte[]) : MessageSet =
  { offset = 0L
    messages = [ create_simple_msg msg ]}

let serialize_message (stream : MemoryStream) msg = 
  stream.write_int<Crc32> msg.crc
  stream.write_byte msg.magic_byte
  stream.write_byte (int8 msg.attributes)
  write_byte_array stream msg.key
  write_byte_array stream msg.value

let serialize message_set (stream : MemoryStream) = 
  stream.write_int<Offset> message_set.offset
  write_array<Message> stream message_set.messages serialize_message

let deserialize_message (stream : MemoryStream) = 
  { crc = stream.read_int32<Crc32>()
    magic_byte = stream.read_byte()
    attributes = enum<Compression> (stream.read_byte() |> int32)
    key = read_byte_array stream
    value = read_byte_array stream }

let deserialize (stream : MemoryStream) = 
  { offset = stream.read_int64<Offset>()
    messages = read_array<Message> stream deserialize_message }
