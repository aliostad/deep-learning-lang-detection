(*
    eLyKseeR or LXR - cryptographic data archiving software
    https://github.com/CodiePP/elykseer-base
    Copyright (C) 2017 Alexander Diemand

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)

namespace SBCLab.LXR

open FileCtrl
open System
open System.IO

module Chunk =

    type t = {
        mutable buf : byte array;
    }

    exception InvalidIndex of int
    exception NoAccess
    exception AlreadyExists
    exception BadNumber

    //[<Literal>]
    //let maxcid = 256
    //[<Literal>]
    let width = 256
    //[<Literal>]
    let height = 1024

    let size = width * height
    (** the length of a chunk is 256 kB *)

    let create () =
        { buf=Array.create size (byte 0) }

    let copyBytes c bytes =
        let rec copyBytes' (c : t) (bytes : byte array) idx = 
            if idx >= size then c
            else begin
                c.buf.[idx] <- bytes.[idx];
                copyBytes' c bytes (idx + 1)
            end
        in
        copyBytes' c bytes 0 |> ignore

    let fromFile fp = 
        if FileCtrl.isFileReadable fp then () else raise NoAccess;
        let c = create () in
        //let istr = open_in_bin fp in
        //let nbytes = input istr c.buf 0 size in
        //close_in istr;
        //Printf.printf "read %d bytes\n" nbytes;
        let bytes = File.ReadAllBytes(fp) in
        copyBytes c bytes;
        c

    let toFile c fp =
        if FileCtrl.fileExists fp then raise AlreadyExists;
        //let ostr = open_out_bin fp in
        //let res = try begin
        //    output ostr c.buf 0 size; true
        //    end with
        //    | _ -> false
        //in
        //close_out ostr;
        (*Printf.printf "written %d bytes\n" size;*)
        //res
        File.WriteAllBytes(fp, c.buf);
        true

    let empty c = c.buf <- Array.empty; ()

    let get c idx = 
        if idx >= size then raise (InvalidIndex idx)
        else c.buf.[idx]

    let set c idx b = 
        if idx >= size then raise (InvalidIndex idx)
        else c.buf.[idx] <- b
        |> ignore

#if DEBUG
    let show c =
        for row = 1 to height do
            Console.Write(sprintf "%4i " row)
            for col = 1 to width do
                Console.Write(sprintf "%2x " c.buf.[(row-1) * width + (col-1)])
            done
            Console.WriteLine("")
        done
#endif
