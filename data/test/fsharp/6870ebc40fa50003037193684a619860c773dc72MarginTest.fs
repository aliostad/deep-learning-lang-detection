(* Copyright 2014 FSharpN00b.
This file is part of Tagger.

Tagger is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Tagger is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Tagger.  If not, see <http://www.gnu.org/licenses/>.

Tagger uses AvalonEdit, which is copyright 2014 AlphaSierraPapa for the SharpDevelop Team under the terms of the MIT License. For more information see www.avalonedit.net. *)

module MarginTest

open Xunit

// TaggerMargin
open TaggerControls
open TestHelpers

(*
Functions to test:

Highlight:
N tick_handler
N show (UI function)
N hide (UI function)
N redraw (UI function)
N scroll (UI function)
N contains_y_position (UI function)

TaggerMargin:
Functions:
N show_open_tag_rect (UI function)
N show_drag_from_rect (UI function)
N show_drag_to_rect (UI function)
N get_drag_effect (UI function)
N drop_handler_helper (UI function)
N mouse_up_helper (UI function)
N mouse_move_handler (UI function)
N mouse_left_up_handler (UI function)
N mouse_right_up_handler (UI function)
N drop_handler (UI function)
N drag_over_handler (UI function)
N drag_leave_handler (UI function)
N query_continue_drag_handler (UI function)
N hide_drag_from_rect (UI function)
N hide_drag_to_rect (UI function)
N scroll (UI function)
N show (UI function)
N redraw (UI function)
N drag_over_helper (UI function)

 Events:
N _select (mouse_left_up_handler)
N _right_click (mouse_right_up_handler)
N _drop (drop_handler_helper)
N _drag_start (mouse_move_handler)
N _drag_over (drag_over_helper)
N _drag_end (query_continue_drag_handler)
N _debug ()
*)

type MarginTest () =
    interface ITestGroup with

    member this.tests_log with get () = []
    member this.tests_throw with get () = []
    member this.tests_no_log with get () = []
