(*
 * Copyright (c) 2012--2014 MSR-INRIA Joint Center. All rights reserved.
 * 
 * This code is distributed under the terms for the CeCILL-B (version 1)
 * license.
 * 
 * You should have received a copy of the CeCILL-B (version 1) license
 * along with this program.  If not, see:
 * 
 *   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt
 *)

module Error

type ('a,'b) optResult =
    | Error of 'a
    | Correct of 'b

val perror: string -> string -> string -> string
val correct: 'a -> ('b,'a) optResult
val unexpected: string -> 'a
val unreachable: string -> 'a
