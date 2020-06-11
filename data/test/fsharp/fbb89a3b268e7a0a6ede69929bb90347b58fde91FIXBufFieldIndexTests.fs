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
 
module FIXBufIndexerUnitTest

open Xunit
open Swensen.Unquote

open FIXBufIndexer

let convFieldSep (bb:byte) = 
    match bb with 
    | 124uy -> 1uy
    | n     -> n



//// compound write, of a length field and the corresponding string field
//let WriteRawData (dest:byte []) (pos:int) (fld:RawData) : int =
//    WriteFieldLengthData dest pos "95="B "96="B fld

[<Fact>]
let ``index FIX buf, including len+data field RawData with data containing only 5 tag-value seperators`` () =
    // 95=5|96=xx|xx contains the field seperator (between xx's), position should not matter
    let fixBuf = "95=5|96======|8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|108=30|10=157|"B |> Array.map convFieldSep
    let numFields = 11 // len+data field counts as one
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> numFields // the expected length
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length
    let expectedIndex = [|  
        FIXBufIndexer.FieldPos( 95, 3, 10) // rawdata len 
        FIXBufIndexer.FieldPos( 8, 16, 7)
        FIXBufIndexer.FieldPos( 9, 26, 2)
        FIXBufIndexer.FieldPos( 35, 32, 1)
        FIXBufIndexer.FieldPos( 49, 37, 4)
        FIXBufIndexer.FieldPos( 56, 45, 6)
        FIXBufIndexer.FieldPos( 34, 55, 1)
        FIXBufIndexer.FieldPos( 52, 60, 17)
        FIXBufIndexer.FieldPos( 98, 81, 1)
        FIXBufIndexer.FieldPos( 108, 87, 2)
        FIXBufIndexer.FieldPos( 10, 93, 3)
        |]

    numFields =! indexEnd
    expectedIndex =! indexArr




[<Fact>]
let ``index FIX buf, including len+data field RawData with data containing 5 field seperators`` () =
    // 95=5|96=xx|xx contains the field seperator (between xx's), position should not matter
    let fixBuf = "95=5|96=||||||8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|108=30|10=157|"B |> Array.map convFieldSep
    let numFields = 11 // len+data field counts as one
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> numFields // the expected length
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length
    let expectedIndex = [|  
        FIXBufIndexer.FieldPos( 95, 3, 10) // rawdata len 
        FIXBufIndexer.FieldPos( 8, 16, 7)
        FIXBufIndexer.FieldPos( 9, 26, 2)
        FIXBufIndexer.FieldPos( 35, 32, 1)
        FIXBufIndexer.FieldPos( 49, 37, 4)
        FIXBufIndexer.FieldPos( 56, 45, 6)
        FIXBufIndexer.FieldPos( 34, 55, 1)
        FIXBufIndexer.FieldPos( 52, 60, 17)
        FIXBufIndexer.FieldPos( 98, 81, 1)
        FIXBufIndexer.FieldPos( 108, 87, 2)
        FIXBufIndexer.FieldPos( 10, 93, 3)
        |]

    numFields =! indexEnd
    expectedIndex =! indexArr


[<Fact>]
let ``index FIX buf, including len+data field RawData with data containing a tag-value seperator`` () =
    // 95=5|96=xx|xx contains the field seperator (between xx's), position should not matter
    let fixBuf = "95=5|96=xx=xx|8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|108=30|10=157|"B |> Array.map convFieldSep
    let numFields = 11 // len+data field counts as one
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> numFields // the expected length
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length
    let expectedIndex = [|  
        FIXBufIndexer.FieldPos( 95, 3, 10) // rawdata len 
        FIXBufIndexer.FieldPos( 8, 16, 7)
        FIXBufIndexer.FieldPos( 9, 26, 2)
        FIXBufIndexer.FieldPos( 35, 32, 1)
        FIXBufIndexer.FieldPos( 49, 37, 4)
        FIXBufIndexer.FieldPos( 56, 45, 6)
        FIXBufIndexer.FieldPos( 34, 55, 1)
        FIXBufIndexer.FieldPos( 52, 60, 17)
        FIXBufIndexer.FieldPos( 98, 81, 1)
        FIXBufIndexer.FieldPos( 108, 87, 2)
        FIXBufIndexer.FieldPos( 10, 93, 3)
        |]

    numFields =! indexEnd
    expectedIndex =! indexArr



[<Fact>]
let ``index FIX buf, including len+data field RawData with data containing a field seperator`` () =
    // 95=5|96=xx|xx contains the field seperator (between xx's), position should not matter
    let fixBuf = "95=5|96=xx|xx|8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|108=30|10=157|"B |> Array.map convFieldSep
    let numFields = 11 // len+data field counts as one
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> numFields // the expected length
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length
    let expectedIndex = [|  
        FIXBufIndexer.FieldPos( 95, 3, 10) // rawdata len 
        FIXBufIndexer.FieldPos( 8, 16, 7)
        FIXBufIndexer.FieldPos( 9, 26, 2)
        FIXBufIndexer.FieldPos( 35, 32, 1)
        FIXBufIndexer.FieldPos( 49, 37, 4)
        FIXBufIndexer.FieldPos( 56, 45, 6)
        FIXBufIndexer.FieldPos( 34, 55, 1)
        FIXBufIndexer.FieldPos( 52, 60, 17)
        FIXBufIndexer.FieldPos( 98, 81, 1)
        FIXBufIndexer.FieldPos( 108, 87, 2)
        FIXBufIndexer.FieldPos( 10, 93, 3)
        |]

    numFields =! indexEnd
    expectedIndex =! indexArr




[<Fact>]
let ``reconstruct FIX buf from index, contains len+data fields with data field containing a field seperator`` () =
    // 95=5|96=xx|xx contains the field seperator
    let fixBuf = "8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|95=5|96=xx|xx|108=30|10=157|"B |> Array.map convFieldSep
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> 256
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length
    let fixBuf2 = FIXBufIndexer.reconstructFromIndex fixBuf indexArr indexEnd
//    let s1 = FIXBuf.toS fixBuf fixBuf.Length
//    let s2 = FIXBuf.toS fixBuf2 fixBuf2.Length
    fixBuf =! fixBuf2




[<Fact>]
let ``index simple FIX buf, no len+data fields`` () =
    let fixBuf = "8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|108=30|10=157|"B |> Array.map convFieldSep
    let numFields = 10
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> numFields
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length

    let expectedIndex = [|  
        FIXBufIndexer.FieldPos( 8, 2, 7)
        FIXBufIndexer.FieldPos( 9, 12, 2)
        FIXBufIndexer.FieldPos( 35, 18, 1)
        FIXBufIndexer.FieldPos( 49, 23, 4)
        FIXBufIndexer.FieldPos( 56, 31, 6)
        FIXBufIndexer.FieldPos( 34, 41, 1)
        FIXBufIndexer.FieldPos( 52, 46, 17)
        FIXBufIndexer.FieldPos( 98, 67, 1)
        FIXBufIndexer.FieldPos( 108, 73, 2)
        FIXBufIndexer.FieldPos( 10, 79, 3)
        |]


    numFields =! indexEnd
    expectedIndex =! indexArr



[<Fact>]
let ``reconstruct FIX buf from index, no len+data fields`` () =
    let fixBuf = "8=FIX.4.4|9=61|35=A|49=FUND|56=BROKER|34=1|52=20170104-06:22:00|98=0|108=30|10=157|"B |> Array.map convFieldSep
    let indexArr = Array.zeroCreate<FIXBufIndexer.FieldPos> 256
    let indexEnd = FIXBufIndexer.BuildIndex indexArr fixBuf fixBuf.Length
    let fixBuf2 = FIXBufIndexer.reconstructFromIndex fixBuf indexArr indexEnd
    fixBuf =! fixBuf2
