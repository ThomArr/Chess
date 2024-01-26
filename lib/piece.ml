type shape = King of bool | Queen | Rook | Bishop | Horse | Pawn of bool
type color = Black | White
type piece = { shape : shape; color : color }

let pp_piece fmt piece =
  let p_str =
    match piece.shape with
    | King _ -> ( match piece.color with Black -> "♚" | White -> "♔")
    | Queen -> ( match piece.color with Black -> "♛" | White -> "♕")
    | Rook -> ( match piece.color with Black -> "♜" | White -> "♖")
    | Bishop -> ( match piece.color with Black -> "♝" | White -> "♗")
    | Horse -> ( match piece.color with Black -> "♞" | White -> "♘")
    | Pawn _ -> ( match piece.color with Black -> "♟" | White -> "♙")
  in
  Format.fprintf fmt "%s" p_str
