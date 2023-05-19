{
type error =
  | Illegal_character of char

let pp_error ppf = function
  | Illegal_character chr -> Fmt.pf ppf "Illegal character %S" (String.make 1 chr)

exception Error of error * Location.t

let error lexbuf err =
  raise (Error (err, Location.of_lexbuf lexbuf))

open Parser
}

let digit = ['0' - '9']

rule token = parse
  | [ ' ' '\n' '\t' ]+ { token lexbuf }
  | digit+ as n { NUMBER (int_of_string n) }
  | '+' { PLUS }
  | '-' { MINUS }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "true" { NUMBER 1 }
  | "false" { NUMBER 0 }
  | "&&" { AND }
  | "=" { EQUAL }
  
  | eof { EOF }
  | _ as chr
      { error lexbuf (Illegal_character chr) }

{

}
