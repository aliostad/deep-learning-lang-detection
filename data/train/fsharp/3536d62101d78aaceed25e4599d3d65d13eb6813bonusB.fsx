(*

   ITT8060 -- Advanced Programming 2014
   Department of Computer Science
   Tallinn University of Technology
   ------------------------------------

   Bonus coursework B:  Computation expressions

   ------------------------------------
   Name:
   Student ID:
   ------------------------------------


   Answer the questions below.  You answers to questions 1--4 should be
   correct F# code written after the question. This file is an F#
   script file, it should be possible to load the whole file at
   once. If you can't then you have introduced a syntax error
   somewhere.

   This coursework is optional but you can get extra bonus marks (up to 3).
   Please submit it as bonusB/bonusB.fsx in the Git system at git.ttu.ee.

   The deadline for completing the above procedure is Sunday, December 7, 2014.

*)

// this a type of expressions, it has changed a little from the lecture

type Exp<'x> = | Val of int | Add of Exp<'x> * Exp<'x> | Var of 'x

// 1. write a function that changes (renames) the variables in the expression
//
//      ren : Exp<'x> -> list<'x,'y> -> Exp<'y>
//
//    hide the threaded environment using computation expressions
//
//    e.g. ren (Var 'c') ['c',"c"] = Var "c"

// 2. write a function that substitutes variables for values in the expression
//
//      sub : Exp<'x> -> list<'x,Exp<'y>> -> Exp<'y>
//
//    hide the threaded environment using computation expressions
//
//    e.g. sub (Var 'c') ['c',Val 2;'d',Var 'd'] = Val 2

// 3. write a evaluator that might fail (due to a failed variable lookup)
//
//    eval : Exp<'x> -> list<'x,int> -> int option
//
//    You will need to modify lookup also. Use the computation syntax
//    for option to manage to possible failure but thread the
//    environment explicitly.
//
//    e.g. eval (Var 'c') ['c',2] = Some 2
//         eval (Var 'c') ['d',3] = None

// 4. (very tricky! very optional) write an evaluator that hides
//    the environment and manages failure, you probably need to define
//    a new builder (i.e. a new monad) that combines both facilities.
