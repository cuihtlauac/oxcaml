(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 2023 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(* Shared types to help break dependency cycles *)

(* Float width type, shared between multiple modules *)
type float_width =
  | Float64
  | Float32

let equal_float_width fw1 fw2 =
  match fw1, fw2 with
  | Float64, Float64 -> true
  | Float32, Float32 -> true
  | _ -> false