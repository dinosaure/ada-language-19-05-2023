type t =
  | Nowhere
  | Multiline of { start : int * int; stop : int * int }
  | Line of { line : int; start : int; stop : int }

let line ~line start stop =
  Line { line; start; stop; }

let multiline start stop =
  Multiline { start; stop; }

let pp ppf = function
  | Nowhere -> ()
  | Line { line; start; stop } -> Fmt.pf ppf "l%d.%d-%d" line start stop
  | Multiline { start = l1, c1; stop = l2, c2 } ->
      Fmt.pf ppf "l%d.%d-l%d.%d" l1 c1 l2 c2

let of_lexbuf lexbuf =
 let open Lexing in
  let extract v =
    (v.pos_lnum, v.pos_cnum - v.pos_bol) in
  let ((l0, c0) as v) = extract lexbuf.lex_start_p in
  let ((l1, c1) as w) = extract lexbuf.lex_curr_p in
  if l0 = l1
  then line ~line:l0 c0 c1
  else multiline v w

let lines_of_fpath fpath =
  Bos.OS.File.with_ic fpath @@ fun ic ->
  let rec go acc = match input_line ic with
    | line -> go (line :: acc)
    | exception End_of_file -> acc in
  go

let range lines ~start ~stop =
  let rec go acc idx = function
    | [] -> List.rev acc
    | x :: r when idx >= start && idx <= stop ->
        go (x :: acc) (succ idx) r
    | _ :: r -> go acc (succ idx) r in
  go [] 0 lines

let of_file fpath ppf = function
  | Nowhere -> Fmt.pf ppf "%a: nowhere" Fpath.pp fpath
  | Line { line; start; stop; } ->
    let lines =
      lines_of_fpath fpath []
      |> Rresult.R.failwith_error_msg
      |> List.rev in
    Fmt.pr "%d| %s\n%!" line (List.nth lines (pred line));
    Fmt.pr "%*s| %s%s\n%!" ((pred line) mod 10) " " (String.make start ' ') (String.make (stop - start) '^')
  | Multiline { start= (start, _); stop= (stop, _); } ->
    let lines =
      lines_of_fpath fpath []
      |> Rresult.R.failwith_error_msg
      |> List.rev in
    let lines = range ~start:(pred start) ~stop:(pred stop) lines in
    List.iter (Fmt.pr "%s\n%!") lines
