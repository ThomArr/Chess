open Global
open Piece
open Board

type strategy = {
  choose_move : color -> board -> move;
  choose_accept_draw : color -> board -> bool;
  choose_promotion : color -> board -> shape;
}

type player = { color : color; strategy : strategy }

let init_player color strategy = { color; strategy }
let get_color_from_player (p : player) = p.color
let get_choose_move_from_player (p : player) = p.strategy.choose_move p.color
let get_choose_accept_draw (p : player) = p.strategy.choose_accept_draw p.color
let get_choose_promotion (p : player) = p.strategy.choose_promotion p.color

let rec request_action question =
  Format.printf "%s:@ " question;
  Format.print_flush ();
  try
    Scanf.scanf "%s@\n" (fun s ->
        if s = "bc" then Big_Castling
        else if s = "sc" then Small_Castling
        else if s = "d" then Propose_Draw
        else if s = "gu" then Give_Up
        else if String.length s <> 5 || s.[2] <> ' ' then (
          Format.printf "Invalid entry.@;";
          request_action question)
        else
          let coord = String.split_on_char ' ' s in
          if List.length coord <> 2 then (
            Format.printf "Invalid entry.@;";
            request_action question)
          else
            let (x1, y1), (x2, y2) =
              ( convert_coordinates (List.nth coord 0),
                convert_coordinates (List.nth coord 1) )
            in
            if
              (not (is_valid_coordinates (x1, y1)))
              || not (is_valid_coordinates (x2, y2))
            then (
              Format.printf "Invalid entry.@;";
              request_action question)
            else Movement ((x1, y1), (x2, y2)))
  with Failure _ ->
    Format.printf "Invalid entry.@;";
    request_action question

let rec request_yes_or_no question =
  Format.printf "%s (y or n to answer):@ " question;
  Format.print_flush ();
  Scanf.scanf "%s@\n" (fun s ->
      if s = "y" then true
      else if s = "n" then false
      else (
        Format.printf "Invalid entry : your answer is not correct.@;";
        request_yes_or_no question))

let rec request_piece question =
  Format.printf "%s (y or n to answer):@ " question;
  Format.print_flush ();
  Scanf.scanf "%s@\n" (fun s ->
      if s = "Q" then Queen
      else if s = "R" then Rook false
      else if s = "B" then Bishop
      else if s = "K" then Knight
      else (
        Format.printf "Invalid entry : your answer is not correct.@;";
        request_piece question))

let default_choose_move _ _ =
  request_action
    "Choose move on format : \"start finish\" (example : a2 a3) or \"bc\" for \
     big castling or \"sc\" for small castling or \"d\" to propose draw or \
     \"gu\" for give up."

let default_choose_accept_draw _ _ =
  request_yes_or_no "Do you want to accept draw?"

let default_choose_promotion _ _ =
  request_piece
    "What do you want to turn your pawn into? (Q for Queen, R for Rook, B for \
     Bishop and K for Knight)"

let default_strategy () =
  {
    choose_move = default_choose_move;
    choose_accept_draw = default_choose_accept_draw;
    choose_promotion = default_choose_promotion;
  }
