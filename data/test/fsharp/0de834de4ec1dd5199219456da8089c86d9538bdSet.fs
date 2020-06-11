(*
Set : unit tests for the EmuUtil.NetFPGA_Util.SetBytes method
Jonny Shipton, Cambridge University Computer Lab, August 2016

This software was developed by the University of Cambridge,
Computer Laboratory under EPSRC NaaS Project EP/K034723/1 

Use of this source code is governed by the Apache 2.0 license; see LICENSE file
*)

namespace EmuUtilTests.NetFPGA_Util

open FsCheck
open FsCheck.Xunit
open global.Xunit
open Swensen.Unquote.Assertions

open EmuUtil

module Set =
    // Array for const tests - the data has no meaning
    let dataArr =
        [|  0x0706050403020100uL;
            0x0f0e0d0c0b0a0908uL;
            0x1716151413121110uL; |]

    // Tests for SetBytes
    [<Fact>]
    let ``SetBytes(dataArr, 0, ..., 8)`` () =
        // Check that setting the first 8 bytes is equivalent to setting the first ulong in the array
        let data = Array.copy dataArr // Copy the data array so we don't change the original
        NetFPGA_Util.SetBytes(data, 0, 0xf7f6f5f4f3f2f1f0uL, 8)
        data =!
            [|  0xf7f6f5f4f3f2f1f0uL;
                0x0f0e0d0c0b0a0908uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``SetBytes(dataArr, 2, ..., 8)`` () =
        // Check that setting 8 bytes across a boundary (meaning data is in two different ulongs) works
        let data = Array.copy dataArr // Copy the data array so we don't change the original
        NetFPGA_Util.SetBytes(data, 2, 0xf7f6f5f4f3f2f1f0uL, 8)
        data =!
            [|  0xf5f4f3f2f1f00100uL;
                0x0f0e0d0c0b0af7f6uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``SetBytes(dataArr, 2, ..., 6)`` () =
        // Check that setting 6 bytes at an offset of 2 works
        let data = Array.copy dataArr // Copy the data array so we don't change the original
        NetFPGA_Util.SetBytes(data, 2, 0xf7f6f5f4f3f2f1f0uL, 6)
        data =!
            [|  0xf5f4f3f2f1f00100uL;
                0x0f0e0d0c0b0a0908uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``SetBytes(dataArr, 2, ..., 4)`` () =
        // Check that setting 4 bytes at an offset of 2 works. This checks that the bits are masked properly,
        // as the target data is in the middle with bits either side.
        let data = Array.copy dataArr // Copy the data array so we don't change the original
        NetFPGA_Util.SetBytes(data, 2, 0xf7f6f5f4f3f2f1f0uL, 4)
        data =!
            [|  0x0706f3f2f1f00100uL;
                0x0f0e0d0c0b0a0908uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``SetBytes(dataArr, 3, ..., 6)`` () =
        // Check that setting 6 bytes at an offset of 3 works. This is an odd offset, and also crosses a
        // boundary (so data is in two different ulongs)
        let data = Array.copy dataArr // Copy the data array so we don't change the original
        NetFPGA_Util.SetBytes(data, 3, 0xf7f6f5f4f3f2f1f0uL, 6)
        data =!
            [|  0xf4f3f2f1f0020100uL;
                0x0f0e0d0c0b0a09f5uL;
                0x1716151413121110uL; |]

    // Generator of random data for Set(...)
    let setGen =
        Arb.fromGen
            (gen {
                // Generate an array of size 1-4
                let! len = Gen.choose (1, 4)
                let! arr = Gen.arrayOfLength len Arb.from<uint64>.Generator
                // Generate a valid offset
                let! offset = Gen.choose (0, len * 8 - 1)
                // Generate a valid value
                let! value = Arb.from<uint64>.Generator
                // Generate a valid length
                let! length = Gen.choose (1, System.Math.Min(8, len * 8 - offset))
                return (arr, offset, value, length)
            })

    // 'Reference' implementation of Set for testing against
    let altSet (data:uint64[], offset, value, length) =
        let valueArr = Array.create 1 value
        System.Buffer.BlockCopy(valueArr, 0, data, offset, length)

    // Test Set(...) against the reference impl on random data
    [<Property>]
    let ``Set(dataArr, offset, value, length) works with random data`` () =
        Prop.forAll setGen (fun ((data, offset, value, length) as p) ->
            // Copy the data array so we don't change the original
            let data' = Array.copy data
            // Run the method being tested
            NetFPGA_Util.SetBytes(data', offset, value, length)
            // Make another copy of the data
            let data'' = Array.copy data
            // Run the reference method
            altSet(data'', offset, value, length)
            // Check they produce the same result
            data' =! data''
        )

    // Tests for altSet (the reference Set implementation). These are the same as the const tests for SetByte above
    [<Fact>]
    let ``altSet(dataArr, 0, ..., 8)`` () =
        let data = Array.copy dataArr
        altSet(data, 0, 0xf7f6f5f4f3f2f1f0uL, 8)
        data =!
            [|  0xf7f6f5f4f3f2f1f0uL;
                0x0f0e0d0c0b0a0908uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``altSet(dataArr, 2, ..., 8)`` () =
        let data = Array.copy dataArr
        altSet(data, 2, 0xf7f6f5f4f3f2f1f0uL, 8)
        data =!
            [|  0xf5f4f3f2f1f00100uL;
                0x0f0e0d0c0b0af7f6uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``altSet(dataArr, 2, ..., 6)`` () =
        let data = Array.copy dataArr
        altSet(data, 2, 0xf7f6f5f4f3f2f1f0uL, 6)
        data =!
            [|  0xf5f4f3f2f1f00100uL;
                0x0f0e0d0c0b0a0908uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``altSet(dataArr, 2, ..., 4)`` () =
        let data = Array.copy dataArr
        altSet(data, 2, 0xf7f6f5f4f3f2f1f0uL, 4)
        data =!
            [|  0x0706f3f2f1f00100uL;
                0x0f0e0d0c0b0a0908uL;
                0x1716151413121110uL; |]

    [<Fact>]
    let ``altSet(dataArr, 3, ..., 6)`` () =
        let data = Array.copy dataArr
        altSet(data, 3, 0xf7f6f5f4f3f2f1f0uL, 6)
        data =!
            [|  0xf4f3f2f1f0020100uL;
                0x0f0e0d0c0b0a09f5uL;
                0x1716151413121110uL; |]
