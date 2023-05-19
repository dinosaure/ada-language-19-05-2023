type t = Int of int

let rec eval = function
  | Ast.Int n -> Int n
  | Ast.Plus (a, b) -> (
      match (eval a, eval b) with Int a, Int b -> Int (a + b))
  | Ast.Minus (a, b) -> (
      match (eval a, eval b) with Int a, Int b -> Int (a - b))
  | Ast.And (a, b) -> (
      (* 0 && _ -> false *)
      (* _ && 0 -> false *)
      match (eval a, eval b) with Int 0, _ | _, Int 0 -> Int 0 | _, _ -> Int 1)
  | Ast.Equal (a, b) -> (
      match (eval a, eval b) with
      | Int a, Int b -> if a = b then Int 1 else Int 0)
  | Ast.If (t, a, b) -> ( match eval t with Int 0 -> eval b | Int _ -> eval a)

let pp ppf = function Int n -> Fmt.int ppf n
