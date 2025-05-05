open Stdlib

external int64x4_of_int64s : int64 -> int64 -> int64 -> int64 -> int64x4
  = "" "vec256_of_int64s"
  [@@noalloc] [@@unboxed]

external int64x4_first_int64 : int64x4 -> int64 = "" "vec256_first_int64"
  [@@noalloc] [@@unboxed]

external int64x4_second_int64 : int64x4 -> int64 = "" "vec256_second_int64"
  [@@noalloc] [@@unboxed]

external int64x4_third_int64 : int64x4 -> int64 = "" "vec256_third_int64"
  [@@noalloc] [@@unboxed]

external int64x4_fourth_int64 : int64x4 -> int64 = "" "vec256_fourth_int64"
  [@@noalloc] [@@unboxed]

let eq l r = if l <> r then Printf.printf "%Ld <> %Ld\n" l r

let[@inline never] check v a b c d =
  let v1, v2, v3, v4 =
    ( int64x4_first_int64 v,
      int64x4_second_int64 v,
      int64x4_third_int64 v,
      int64x4_fourth_int64 v )
  in
  eq v1 a;
  eq v2 b;
  eq v3 c;
  eq v4 d

let[@inline never] combine v0 v1 =
  let a0, b0, c0, d0 =
    ( int64x4_first_int64 v0,
      int64x4_second_int64 v0,
      int64x4_third_int64 v0,
      int64x4_fourth_int64 v0 )
  in
  let a1, b1, c1, d1 =
    ( int64x4_first_int64 v1,
      int64x4_second_int64 v1,
      int64x4_third_int64 v1,
      int64x4_fourth_int64 v1 )
  in
  int64x4_of_int64s (Int64.add a0 a1) (Int64.add b0 b1) (Int64.add c0 c1)
    (Int64.add d0 d1)

let[@inline never] combine_with_floats v0 f0 v1 f1 =
  let a0, b0, c0, d0 =
    ( int64x4_first_int64 v0,
      int64x4_second_int64 v0,
      int64x4_third_int64 v0,
      int64x4_fourth_int64 v0 )
  in
  let a1, b1, c1, d1 =
    ( int64x4_first_int64 v1,
      int64x4_second_int64 v1,
      int64x4_third_int64 v1,
      int64x4_fourth_int64 v1 )
  in
  let a, b, c, d =
    Int64.add a0 a1, Int64.add b0 b1, Int64.add c0 c1, Int64.add d0 d1
  in
  let a = Int64.add (Int64.of_float f0) a in
  let b = Int64.add (Int64.of_float f1) b in
  int64x4_of_int64s a b c d

(* Identity *)
let () =
  let v = int64x4_of_int64s 1L 2L 3L 4L in
  let v = Sys.opaque_identity v in
  check v 1L 2L 3L 4L

(* Identity fn *)
let () =
  let v = int64x4_of_int64s 1L 2L 3L 4L in
  let[@inline never] id v = v in
  let v = id v in
  check v 1L 2L 3L 4L

(* Pass to function *)
let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v = combine v0 v1 in
  check v 6L 8L 10L 12L

(* Pass to function (inlined) *)
let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v = (combine [@inlined hint]) v0 v1 in
  check v 6L 8L 10L 12L

(* Pass to function with floats *)
let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let f0 = Sys.opaque_identity 9. in
  let v = combine_with_floats v0 f0 v1 10. in
  check v 15L 18L 10L 12L

(* Pass to function with floats (inlined) *)
let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v = (combine_with_floats [@inlined hint]) v0 9. v1 10. in
  check v 15L 18L 10L 12L

(* Capture in closure *)
let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let f = combine v0 in
  let f = Sys.opaque_identity f in
  let v = f v1 in
  check v 6L 8L 10L 12L

(* Capture vectors and floats in a closure *)
let () =
  let[@inline never] f v0 v1 f0 v2 f1 v3 =
    combine (combine_with_floats v0 f0 v1 f1) (combine v2 v3)
  in
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v2 = int64x4_of_int64s 9L 10L 11L 12L in
  let v3 = int64x4_of_int64s 13L 14L 15L 16L in
  let f = f v0 v1 17. v2 in
  let f = Sys.opaque_identity f in
  let v = f 18. v3 in
  check v 45L 50L 36L 40L

(* Capture vectors and floats in a closure (inlined) *)
let () =
  let[@inline always] f v0 v1 f0 v2 f1 v3 =
    (combine [@inlined hint])
      ((combine_with_floats [@inlined hint]) v0 f0 v1 f1)
      ((combine [@inlined hint]) v2 v3)
  in
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v2 = int64x4_of_int64s 9L 10L 11L 12L in
  let v3 = int64x4_of_int64s 13L 14L 15L 16L in
  let f = f v0 v1 17. v2 in
  let v = f 18. v3 in
  check v 45L 50L 36L 40L

(* Store in record *)
type record =
  { a : int64x4;
    mutable b : int64x4;
    c : float
  }

let () =
  let record =
    { a = int64x4_of_int64s 1L 2L 3L 4L;
      b = int64x4_of_int64s 5L 6L 7L 8L;
      c = 9.
    }
  in
  check record.a 1L 2L 3L 4L;
  check record.b 5L 6L 7L 8L;
  let record = Sys.opaque_identity record in
  record.b <- int64x4_of_int64s 10L 11L 12L 13L;
  check record.a 1L 2L 3L 4L;
  check record.b 10L 11L 12L 13L;
  let v = combine_with_floats record.a record.c record.b 14. in
  check v 20L 27L 15L 17L

(* Store in variant *)
type variant =
  | A of int64x4
  | B of int64x4
  | C of float

let () =
  let variant = A (int64x4_of_int64s 1L 2L 3L 4L) in
  let variant = Sys.opaque_identity variant in
  match variant with
  | A v -> check v 1L 2L 3L 4L
  | _ -> (
    print_endline "fail";
    let variant = ref (C 5.) in
    let variant = Sys.opaque_identity variant in
    variant := B (int64x4_of_int64s 6L 7L 8L 9L);
    match !variant with B v -> check v 6L 7L 8L 9L | _ -> print_endline "fail")

(* Pass boxed vectors to an external *)
external boxed_combine : int64x4 -> int64x4 -> int64x4 = "" "boxed_combine256"
  [@@noalloc]

let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v = boxed_combine v0 v1 in
  check v 6L 8L 10L 12L

(* Pass lots of vectors to an external *)
external lots_of_vectors :
  int64x4 ->
  int64x4 ->
  int64x4 ->
  int64x4 ->
  int64x4 ->
  int64x4 ->
  int64x4 ->
  int64x4 ->
  int64x4 = "" "lots_of_vectors256"
  [@@noalloc] [@@unboxed]

let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v2 = int64x4_of_int64s 9L 10L 11L 12L in
  let v3 = int64x4_of_int64s 13L 14L 15L 16L in
  let v4 = int64x4_of_int64s 17L 18L 19L 20L in
  let v5 = int64x4_of_int64s 21L 22L 23L 24L in
  let v6 = int64x4_of_int64s 25L 26L 27L 28L in
  let v7 = int64x4_of_int64s 29L 30L 31L 32L in
  let v = lots_of_vectors v0 v1 v2 v3 v4 v5 v6 v7 in
  check v 120L 128L 136L 144L

(* Pass mixed floats/vectors to an external *)
external vectors_and_floats :
  int64x4 ->
  float ->
  int64x4 ->
  float ->
  int64x4 ->
  float ->
  int64x4 ->
  float ->
  float ->
  int64x4 ->
  int64x4 ->
  float ->
  float ->
  int64x4 = "" "vectors_and_floats256"
  [@@noalloc] [@@unboxed]

let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v2 = int64x4_of_int64s 9L 10L 11L 12L in
  let v3 = int64x4_of_int64s 13L 14L 15L 16L in
  let v4 = int64x4_of_int64s 17L 18L 19L 20L in
  let v5 = int64x4_of_int64s 21L 22L 23L 24L in
  let v = vectors_and_floats v0 25. v1 26. v2 27. v3 28. 29. v4 v5 30. 31. in
  check v 177L 189L 201L 213L

(* Pass mixed ints/floats/vectors to an external *)
external vectors_and_floats_and_ints :
  int64x4 ->
  float ->
  int64x4 ->
  int64 ->
  int64x4 ->
  float ->
  int64x4 ->
  int64 ->
  int64 ->
  int64x4 ->
  int64x4 ->
  float ->
  float ->
  int64x4 = "" "vectors_and_floats_and_ints256"
  [@@noalloc] [@@unboxed]

let () =
  let v0 = int64x4_of_int64s 1L 2L 3L 4L in
  let v1 = int64x4_of_int64s 5L 6L 7L 8L in
  let v2 = int64x4_of_int64s 9L 10L 11L 12L in
  let v3 = int64x4_of_int64s 13L 14L 15L 16L in
  let v4 = int64x4_of_int64s 17L 18L 19L 20L in
  let v5 = int64x4_of_int64s 21L 22L 23L 24L in
  let v =
    vectors_and_floats_and_ints v0 25. v1 26L v2 27. v3 28L 29L v4 v5 30. 31.
  in
  check v 177L 189L 201L 213L
