# Ada language (19/05/2023)

A simple language to show how to implement one.

## How to use it?

You need to install OCaml (& `opam`):
```shell-session
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
$ opam init
$ opam switch create 4.14.1
$ opam install dune fmt bos rresult
$ cd ada-language-19-05-2023
$ dune build
$ dune exec src/ada.exe --display=quiet -- simple.ada
Some 30
```

## About the architecture

Any computer langugages share the same architecture:
- a lexer (analyse lexicale), you can see `src/lexer.mll`
- a parser (analyse syntaxique), you can see `src/parser.mly`
- an _eval_ (analyse sémantique), which evaluates your
  Abstract Syntax Tree (`src/ast.ml`), you can see `src/eval.ml`

## How to extend the language?

You must:
1) add a new keyword into the `lexer.mll` which must produce
   a _token_
2) define the _token_ into the `parser.mly`
3) extend the `expr` rule or make a new one
4) extend your AST into the `ast.ml`
5) define what you want to do with your new node into the `eval.ml`)
   (define its semantic)
