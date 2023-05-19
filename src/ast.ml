type t =
  | Int of int
  | Plus of t * t
  | Minus of t * t
  | If of t * t * t
  | And of t * t
  | Equal of t * t

let rec pp ppf = function
  | Int n -> Fmt.int ppf n
  | Plus (a, b) -> Fmt.pf ppf "%a+%a" pp a pp b
  | Minus (a, b) -> Fmt.pf ppf "%a+%a" pp a pp b
  | If (t, a, b) -> Fmt.pf ppf "if %a then %a else %a" pp t pp a pp b
  | And (a, b) -> Fmt.pf ppf "%a && %a" pp a pp b
  | Equal (a, b) -> Fmt.pf ppf "%a = %a" pp a pp b
