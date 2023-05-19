let () = Printexc.record_backtrace true

open Rresult

let run () =
  match Sys.argv with
  | [| _; filename |] when Sys.file_exists filename ->
      let fpath = Fpath.v filename in
      let v =
        Driver.of_file fpath Fun.id
        |> R.map (R.reword_error (R.msgf "%a" (Driver.pp_error ~fpath)))
        |> R.join |> R.failwith_error_msg |> Option.map Eval.eval
      in
      Fmt.pr "%a\n%!" Fmt.(Dump.option Eval.pp) v
  | [| _; filename |] ->
      Fmt.epr "%s: %s does not exist.\n%!" Sys.executable_name filename
  | [| _ |] ->
      let v =
        Driver.of_stdin Fun.id
        |> R.reword_error (R.msgf "%a" (Driver.pp_error ?fpath:None))
        |> R.failwith_error_msg |> Option.map Eval.eval
      in
      Fmt.pr "%a\n%!" Fmt.(Dump.option Eval.pp) v
  | _ ->
      Fmt.epr "%s [<filename>]\n%!" Sys.executable_name;
      exit 124

let () =
  try run ()
  with Failure err ->
    Format.eprintf "%s\n" err;
    exit 125
