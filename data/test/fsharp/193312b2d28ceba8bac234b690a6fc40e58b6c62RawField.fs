(*
 * Copyright (C) 2016-2017 Ian Spratt <ian144@hotmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 *)
 

module RawField

open System
open Conversions

open UTCDateTime
open LocalMktDate


open NonEmptyByteArray


let ReadFieldInt bs pos len fldCtor =
    Conversions.bytesToInt32 bs pos len |> fldCtor


let ReadFieldUInt bs pos len fldCtor =
    Conversions.bytesToUInt32 bs pos len |> fldCtor


let ReadFieldChar bs pos len fldCtor =
    Conversions.bytesToChar bs pos len |> fldCtor


let ReadFieldDecimal bs pos len fldCtor =
    Conversions.bytesToDecimal bs pos len |> fldCtor


let ReadFieldBool bs pos (len:int) fldCtor =
    Conversions.bytesToBool bs pos |> fldCtor


let ReadFieldStr bs pos len fldCtor =
    Conversions.bytesToStr bs pos len |> fldCtor

// todo: ReadFieldData allocates, can this be safely avoided, maybe using an ArraySegment?
let ReadFieldData (bs:byte array) pos len fldCtor =
    let subArray = bs.[pos..(pos+len-1)]
    fldCtor subArray


let ReadFieldUTCTimeOnly bs pos len fldCtor =
    UTCDateTime.readUTCTimeOnly bs pos len |> fldCtor


let ReadFieldUTCDate bs pos len fldCtor =
    UTCDateTime.readUTCDate bs pos len |> fldCtor


let ReadFieldLocalMktDate bs pos len fldCtor =
    LocalMktDate.readLocalMktDate bs pos len |> fldCtor


let ReadFieldUTCTimestamp bs pos len fldCtor =
    UTCDateTime.readUTCTimestamp bs pos len |> fldCtor


let ReadFieldTZTimeOnly bs pos (len:int) fldCtor = 
    TZDateTime.readTZTimeOnly bs pos len |> fldCtor


let ReadFieldMonthYear bs pos (len:int) fldCtor =
    MonthYear.read bs pos len |> fldCtor

// pos is pointing to the the begining of the length value
let ReadLengthDataCompoundField (bs:byte[]) (pos:int) (lenTODO:int) (dataTagExpected:byte[]) fldCtor =
    let lengthFieldTermPos = FIXBuf.findNextFieldTermOrEnd bs pos
    let dataFieldLength = Conversions.bytesToInt32 bs pos (lengthFieldTermPos - pos)

    let dataTagPos = lengthFieldTermPos + 1
    // the length of the data has been read, next read the data
    // the tag read-in must match the expected tag
    let dataPos, dataTagBytes = FIXBuf.readTagAfterFieldDelim bs dataTagPos
    if dataTagExpected = dataTagBytes then
        let _, bs = FIXBuf.readNBytesVal dataPos dataFieldLength bs
        let nonEmptyBs = NonEmptyByteArray.Make bs
        nonEmptyBs |> fldCtor
    else
        failwith "ReadLengthDataCompoundField, unexpected string field tag" 



let inline WriteFieldInt (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let vv = (^T :(member Value:int) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = Conversions.ToBytes.Convert(vv)
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter


let inline WriteFieldUint32 (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let vv = (^T :(member Value:uint32) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = Conversions.ToBytes.Convert vv
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter


let inline WriteFieldChar (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let cc = (^T :(member Value:char) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = [|byte(cc)|]
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter


let inline WriteFieldDecimal (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let vv = (^T :(member Value:decimal) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = Conversions.ToBytes.Convert(vv)
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter



let inline WriteFieldBool (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let vv = (^T :(member Value:bool) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = Conversions.ToBytes.Convert(vv)
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter



let inline WriteFieldStr (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let strVal = (^T :(member Value:string) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = Conversions.ToBytes.Convert(strVal)
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter


let inline WriteFieldUTCTimeOnly (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let tm = (^T :(member Value:UTCTimeOnly) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let pos3 =  UTCDateTime.writeUTCTimeOnly tm bs pos2
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter


let inline WriteFieldUTCDate (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let tm = (^T :(member Value:UTCDate) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let pos3 =  UTCDateTime.writeUTCDate tm bs pos2
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter

let inline WriteFieldLocalMktDate (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let tm = (^T :(member Value:LocalMktDate) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let pos3 =  LocalMktDate.writeLocalMktDate tm bs pos2
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter

let inline WriteFieldUTCTimestamp (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let tm = (^T :(member Value:UTCTimestamp) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let pos3 =  UTCDateTime.writeUTCTimestamp tm bs pos2
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter


// not used in FIX4.4, so not tested at the time of writing
// functions called by TZDateTime.writeTZTimeOnly have been tested
let inline WriteFieldTZTimeOnly (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let tm = (^T :(member Value:TZDateTime.TZTimeOnly) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let pos3 =  TZDateTime.writeTZTimeOnly bs pos2 tm
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter



let inline WriteFieldMonthYear (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let tm = (^T :(member Value:MonthYear.MonthYear) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let pos3 =  MonthYear.write bs pos2 tm
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter



let inline WriteFieldData (bs:byte []) (pos:int) (tag:byte[]) (fieldIn:^T) : int = 
    let strVal = (^T :(member Value:string) fieldIn)
    Buffer.BlockCopy (tag, 0, bs, pos, tag.Length)
    let pos2 = pos + tag.Length
    let valBytes = Conversions.ToBytes.Convert(strVal)
    Buffer.BlockCopy (valBytes, 0, bs, pos2, valBytes.Length)
    let pos3 = pos2 + valBytes.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    pos3 + 1 // +1 to move past the delimeter



let inline WriteFieldLengthData (bs:byte []) (pos:int) (lenTag:byte[]) (dataTag:byte[]) (fieldIn:^T) : int =
    let nonEmptyBs = (^T :(member Value:NonEmptyByteArray) fieldIn)
    let dataBs = nonEmptyBs.Value
    // write the len part of the field
    Buffer.BlockCopy (lenTag, 0, bs, pos, lenTag.Length)
    let pos2 = pos + lenTag.Length
    let lenBs = ToBytes.Convert dataBs.Length
    Buffer.BlockCopy (lenBs, 0, bs, pos2, lenBs.Length)
    let pos3 = pos2 + lenBs.Length
    bs.[pos3] <- 1uy // write the SOH field delimeter
    let pos4 = pos3 + 1 // +1 to move past the delimeter
    // write the data part of the compound field
    Buffer.BlockCopy (dataTag, 0, bs, pos4, dataTag.Length)
    let pos5 = pos4 + dataTag.Length
    Buffer.BlockCopy (dataBs, 0, bs, pos5, dataBs.Length)
    let pos6 = pos5 + dataBs.Length
    bs.[pos6] <- 1uy // write the SOH field delimeter
    pos6 + 1 // +1 to move past the delimeter


















