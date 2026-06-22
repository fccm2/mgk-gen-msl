open Xmlerr

let list_find_default f lst def =
  let rec aux = function
  | [] -> def
  | (x::xs) as lst ->
      match f lst with None -> aux xs | Some res -> res
  in
  aux lst

let get_homepage = function
  | Data ("Homepage:") ::
    ETag ("td") ::
    Tag ("td", [
    ]) ::
    Tag ("a", [
      ("href", homepage);
    ]) :: _ -> Some homepage
  | _ -> None

let get_name = function
  | ETag ("div") ::
    Tag ("h2", [
    ]) ::
    Data (name) ::
    ETag ("h2") :: _ -> Some name
  | _ -> None

let () =
  let xs = Xmlerr.parse_ic stdin in
  let xs = Xmlerr.strip_white xs in

  let n = list_find_default get_name xs "NoName" in
  let h = list_find_default get_homepage xs "NoHome" in
  let s1, s2 =
    (Printf.sprintf "(proj (name \"%s\") (home \"%s\"))\n" n h,
     Printf.sprintf "(proj (name \"%s\")\n      (home \"%s\"))\n" n h)
  in
  print_string (
    if String.length s1 <= 80 then s1 else s2)
