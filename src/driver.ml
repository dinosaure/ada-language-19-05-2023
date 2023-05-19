type error = Lexer of Lexer.error * Location.t | Syntax of Location.t

let pp_error ?fpath ppf = function
  | Lexer (err, loc) ->
      Fmt.pf ppf "%a at %a" Lexer.pp_error err Location.pp loc;
      Option.iter (fun fpath -> Location.of_file fpath ppf loc) fpath
  | Syntax loc ->
      Fmt.pf ppf "Syntax error at %a" Location.pp loc;
      Option.iter (fun fpath -> Location.of_file fpath ppf loc) fpath

let of_ic ic =
  let lexbuf = Lexing.from_channel ic in
  try Ok (Parser.prog Lexer.token lexbuf) with
  | Lexer.Error (err, loc) -> Error (Lexer (err, loc))
  | Parser.Error ->
      let loc = Location.of_lexbuf lexbuf in
      Error (Syntax loc)

let of_file fpath = Bos.OS.File.with_ic fpath @@ fun ic f -> f (of_ic ic)
let of_stdin f = f (of_ic stdin)
