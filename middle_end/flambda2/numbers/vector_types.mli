(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                       Pierre Chambart, OCamlPro                        *)
(*           Mark Shinwell and Leo White, Jane Street Europe              *)
(*                                                                        *)
(*   Copyright 2017--2019 OCamlPro SAS                                    *)
(*   Copyright 2017--2019 Jane Street Group LLC                           *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(** SIMD vector numeric type layouts. *)

module Vec128 : sig
  module Bit_pattern : sig
    (** 128-bit value whose comparison and equality relations are lexicographically
      ordered by bit pattern. *)

    include Container_types.S

    val zero : t

    type bits =
      { high : int64;
        low : int64
      }

    val to_bits : t -> bits

    val of_bits : bits -> t
  end
  
  module Set : sig
    include Set.S with type elt = Bit_pattern.t
    
    val print : Format.formatter -> t -> unit
    
    val to_string : t -> string
    
    val union_list : t list -> t
    
    val get_singleton : t -> elt option
  end
end

module Vec256 : sig
  module Bit_pattern : sig
    (** 256-bit value whose comparison and equality relations are lexicographically
      ordered by bit pattern. *)

    include Container_types.S

    val zero : t

    type bits =
      { highest : int64;
        high : int64;
        low : int64;
        lowest : int64
      }

    val to_bits : t -> bits

    val of_bits : bits -> t
  end
  
  module Set : sig
    include Set.S with type elt = Bit_pattern.t
    
    val print : Format.formatter -> t -> unit
    
    val to_string : t -> string
    
    val union_list : t list -> t
    
    val get_singleton : t -> elt option
  end
end

module Vec512 : sig
  module Bit_pattern : sig
    (** 512-bit value whose comparison and equality relations are lexicographically
      ordered by bit pattern. *)

    include Container_types.S

    val zero : t

    type bits =
      { part7 : int64; part6 : int64; part5 : int64; part4 : int64;
        part3 : int64; part2 : int64; part1 : int64; part0 : int64 }

    val to_bits : t -> bits

    val of_bits : bits -> t
  end
  
  module Set : sig
    include Set.S with type elt = Bit_pattern.t
    
    val print : Format.formatter -> t -> unit
    
    val to_string : t -> string
    
    val union_list : t list -> t
    
    val get_singleton : t -> elt option
  end
end
