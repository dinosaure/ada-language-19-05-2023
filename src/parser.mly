%token <int> NUMBER
%token PLUS
%token MINUS
%token IF
%token THEN
%token ELSE
%token AND
%token EQUAL
%token EOF

%start <Ast.t option> prog
%left PLUS
%left MINUS

%%

prog:
  | EOF { None }
  | v = expr EOF { Some v }
  ;

expr:
  | v = NUMBER { Int v }
  | a = expr PLUS b = expr { Plus (a, b) }
  | a = expr MINUS b = expr { Minus (a, b) }
  | IF t = expr THEN a = expr ELSE b = expr
    { If (t, a, b) }
  | a = expr AND b = expr { And (a, b) }
  | a = expr EQUAL b = expr { Equal (a, b) }
