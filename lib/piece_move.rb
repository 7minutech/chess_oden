require_relative "board"
require "pry-byebug"

class PieceMove
  attr_reader :board_obj, :board, :checking_pieces, :white_pieces, :black_pieces

  def initialize
    @board_obj = Board.new
    @board = @board_obj.board
    @board_obj.fill_board
    @king_squares = []
    @white_pieces = []
    @black_pieces = []
    @white_king = nil
    @black_king = nil
    @checking_pieces = []
  end

  def self.convert_chess_notation(chess_notation)
    max_rank = 8
    a_ascii = "a".ord
    file = chess_notation[0]
    rank = chess_notation[1]
    rank = rank.to_i
    rank -= max_rank
    rank = rank.abs
    file = file.ord % a_ascii
    [rank, file]
  end

  def chess_notation_to_square(chess_notation)
    square = PieceMove.convert_chess_notation(chess_notation)
    @board[square[0]][square[1]]
  end

  def remove_impossible_pawn_moves(row, col)
    piece = @board[row][col]
    # binding.pry if row == 3
    piece.possible_moves.dup.each do |move|
      square = @board[move[0]][move[1]]
      if (move[0] - row).abs == 1 && move[1] == col && square != (" ")
        piece.possible_moves.delete([move[0], move[1]])
        if piece.color == :white
          piece.possible_moves.delete([move[0] - 1, move[1]])
        else
          piece.possible_moves.delete([move[0] + 1, move[1]])
        end
        next
      end
      if (move[0] - row).abs == 2 && square != (" ")
        piece.possible_moves.delete([move[0], move[1]])
        next
      end
      next unless move[0] != row && move[1] != col

      piece.possible_moves.delete([move[0], move[1]]) unless square != " " && square.color != piece.color
    end
  end

  def remove_impossible_bishop_moves(row, col)
    piece = @board[row][col]
    remove_diagonal_up_left(row, col, piece)
    remove_diagonal_up_right(row, col, piece)
    remove_diagonal_down_left(row, col, piece)
    remove_diagonal_down_right(row, col, piece)
  end

  def remove_impossible_rook_moves(row, col)
    piece = @board[row][col]
    remove_straight_up(row, col, piece)
    remove_straight_right(row, col, piece)
    remove_straight_down(row, col, piece)
    remove_straight_left(row, col, piece)
  end

  def remove_impossible_queen_moves(row, col)
    remove_impossible_bishop_moves(row, col)
    remove_impossible_rook_moves(row, col)
  end

  def remove_impossible_knight_moves(row, col)
    piece = board[row][col]
    piece.possible_moves.dup.each do |move|
      piece_on_move = board[move[0]][move[1]]
      piece.possible_moves.delete(move) if piece_on_move != " " && piece_on_move.color == piece.color
    end
  end

  def remove_impossible_king_moves
    @king_squares.each do |square|
      piece = board[square[0]][square[1]]
      enemy_moves = []
      (0..7).each do |board_row|
        (0..7).each do |board_col|
          piece_on_square = board[board_row][board_col]
          next unless piece_on_square != " " && piece_on_square.color != piece.color

          piece_on_square.possible_moves.each do |move|
            if piece_on_square.is_a?(Pawn)
              enemy_moves.push(move) if piece_on_square.attacking_moves.include?(move)
            else
              enemy_moves.push(move)
            end
          end
        end
      end
      enemy_moves = enemy_moves.uniq
      piece.possible_moves.dup.each do |move|
        # binding.pry
        piece.possible_moves.delete(move) if enemy_moves.include?(move)
        if board[move[0]][move[1]] != " " && board[move[0]][move[1]].color == piece.color
          piece.possible_moves.delete(move)
        end
      end
    end
  end

  def remove_impossible_moves
    remove_impossible_non_king_moves
    remove_impossible_king_moves
  end

  def create_moves
    (0..7).each do |row|
      (0..7).each do |col|
        piece_on_square = board[row][col]
        next unless piece_on_square != " "

        piece_on_square.create_possible_moves
        if piece_on_square.color == :white

          @white_pieces.push(piece_on_square)
        else
          @black_pieces.push(piece_on_square)
        end
      end
    end
  end

  def create_possible_moves
    create_moves
    remove_impossible_moves
  end

  def clear_moves
    (0..7).each do |row|
      (0..7).each do |col|
        piece_on_square = board[row][col]
        if piece_on_square != " "
          piece_on_square.possible_moves.clear
          piece_on_square.attacking_moves.clear if piece_on_square.is_a?(Pawn)
        end
      end
    end
  end

  def clear_pieces
    @white_pieces.clear
    @black_pieces.clear
  end

  # must create valid moves for other pieces before king
  # other pieces moves dictate where the king can go
  # b/c kings moves that put them in check are invalid
  def remove_impossible_non_king_moves
    (0..7).each do |row|
      (0..7).each do |col|
        piece_on_square = board[row][col]
        if piece_on_square != " " && !piece_on_square.is_a?(King)
          remove_impossible_bishop_moves(row, col) if piece_on_square.is_a?(Bishop)
          remove_impossible_knight_moves(row, col) if piece_on_square.is_a?(Knight)
          remove_impossible_pawn_moves(row, col) if piece_on_square.is_a?(Pawn)
          remove_impossible_queen_moves(row, col) if piece_on_square.is_a?(Queen)
          remove_impossible_rook_moves(row, col) if piece_on_square.is_a?(Rook)
        end
        next unless piece_on_square != " " && piece_on_square.is_a?(King)

        @king_squares.push([row, col])
        @white_king = piece_on_square if piece_on_square.color == :white
        @black_king = piece_on_square if piece_on_square.color == :black
      end
    end
  end

  def remove_diagonal_up_left(row, col, piece)
    while square_in_bounds?(row - 1, col - 1) && @board[row - 1][col - 1] == " "
      row -= 1
      col -= 1
    end
    blocked = true if square_in_bounds?(row - 1, col - 1) && @board[row - 1][col - 1].color == piece.color
    opposite_piece_found = 0
    while square_in_bounds?(row - 1, col - 1)
      row -= 1
      col -= 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_diagonal_up_right(row, col, piece)
    # binding.pry if row == 7 && col == 2
    while square_in_bounds?(row - 1, col + 1) && @board[row - 1][col + 1] == " "
      row -= 1
      col += 1
    end
    blocked = true if square_in_bounds?(row - 1, col + 1) && @board[row - 1][col + 1].color == piece.color

    opposite_piece_found = 0
    while square_in_bounds?(row - 1, col + 1)
      row -= 1
      col += 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_diagonal_down_left(row, col, piece)
    # binding.pry
    while square_in_bounds?(row + 1, col - 1) && @board[row + 1][col - 1] == " "
      row += 1
      col -= 1
    end
    blocked = true if square_in_bounds?(row + 1, col - 1) && @board[row + 1][col - 1].color == piece.color
    opposite_piece_found = 0
    while square_in_bounds?(row + 1, col - 1)
      row += 1
      col -= 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_diagonal_down_right(row, col, piece)
    while square_in_bounds?(row + 1, col + 1) && @board[row + 1][col + 1] == " "
      row += 1
      col += 1
    end
    blocked = true if square_in_bounds?(row + 1, col + 1) && @board[row + 1][col + 1].color == piece.color
    opposite_piece_found = 0
    while square_in_bounds?(row + 1, col + 1)
      row += 1
      col += 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_straight_up(row, col, piece)
    row -= 1 while (row - 1).between?(0, 7) && board[row - 1][col] == " "
    if !(row - 1).between?(0, 7)
      nil
    elsif board[row - 1][col].color == piece.color
      while (row - 1).between?(0, 7)
        piece.possible_moves.delete([row - 1, col])
        row -= 1
      end
    else
      row -= 1
      while (row - 1).between?(0, 7)
        piece.possible_moves.delete([row - 1, col])
        row -= 1
      end
    end
  end

  def remove_straight_right(row, col, piece)
    col += 1 while (col + 1).between?(0, 7) && board[row][col + 1] == " "
    if !(col + 1).between?(0, 7)
      nil
    elsif board[row][col + 1].color == piece.color
      while (col + 1).between?(0, 7)
        piece.possible_moves.delete([row, col + 1])
        col += 1
      end
    else
      col += 1
      while (col + 1).between?(0, 7)
        piece.possible_moves.delete([row, col + 1])
        col += 1
      end
    end
  end

  def remove_straight_down(row, col, piece)
    row += 1 while (row + 1).between?(0, 7) && board[row + 1][col] == " "
    if !(row + 1).between?(0, 7)
      nil
    elsif board[row + 1][col].color == piece.color
      while (row + 1).between?(0, 7)
        piece.possible_moves.delete([row + 1, col])
        row += 1
      end
    else
      row += 1
      while (row + 1).between?(0, 7)
        piece.possible_moves.delete([row + 1, col])
        row += 1
      end
    end
  end

  def remove_straight_left(row, col, piece)
    col -= 1 while (col - 1).between?(0, 7) && board[row][col - 1] == " "
    if !(col - 1).between?(0, 7)
      nil
    elsif board[row][col - 1].color == piece.color
      while (col - 1).between?(0, 7)
        piece.possible_moves.delete([row, col - 1])
        col -= 1
      end
    else
      col -= 1
      while (col - 1).between?(0, 7)
        piece.possible_moves.delete([row, col - 1])
        col -= 1
      end
    end
  end

  def move_piece(old_square, new_square)
    piece = @board[old_square[0]][old_square[1]]
    # binding.pry
    @board[old_square[0]][old_square[1]] = " "
    @board[new_square[0]][new_square[1]] = piece
    piece.current_square = [new_square[0], new_square[1]]
  end

  def square_in_bounds?(row, col)
    return true if row.between?(0, 7) && col.between?(0, 7)

    false
  end

  def check?
    attacking_moves = []
    @white_pieces.each do |piece|
      piece.possible_moves.each do |move|
        attacking_moves.push(move)
      end
    end
    @black_pieces.each do |piece|
      piece.possible_moves.each do |move|
        attacking_moves.push(move)
      end
    end
    attacking_moves = attacking_moves.uniq
    @king_squares.each do |square|
      return true if attacking_moves.include?(square)
    end
    false
  end

  def find_checking_pieces(color_in_check)
    checking_pieces.clear
    if color_in_check == :white
      black_pieces.each do |piece|
        checking_pieces.push(piece) if piece.possible_moves.include?(@white_king.current_square)
      end
    else
      white_pieces.each do |piece|
        checking_pieces.push(piece) if piece.possible_moves.include?(@black_king.current_square)
      end
    end
  end

  def possible_block?
    knight_or_pawn = checking_pieces.any? { |piece| piece.is_a?(Pawn) || piece.is_a?(Knight) }
    unless knight_or_pawn
      return true if checking_pieces.length == 1

      return false

    end
    false
  end

  def checking_path
    checking_piece = checking_pieces[0]
    king = if checking_piece.color == :white
             @black_king
           else
             @white_king
           end
    if checking_path_horizontal?(king.current_square,
                                 checking_piece)
      return horizontal_checking_path(king.current_square,
                                      checking_piece)
    end
    if checking_path_diagonal?(king.current_square, checking_piece)
      return diagonal_up_right_checking_path(king.current_square, checking_piece) if checking_path_diagonal_up_right?(
        king.current_square, checking_piece
      )
      return diagonal_up_left_checking_path(king.current_square, checking_piece) if checking_path_diagonal_up_left?(
        king.current_square, checking_piece
      )

      if checking_path_diagonal_down_right?(
        king.current_square, checking_piece
      )
        return diagonal_down_right_checking_path(king.current_square,
                                                 checking_piece)
      end
      return diagonal_down_left_checking_path(king.current_square, checking_piece) if checking_path_diagonal_down_left?(
        king.current_square, checking_piece
      )
    end
    vertical_checking_path(king.current_square, checking_piece) if checking_path_vertical?(king.current_square,
                                                                                           checking_piece)
  end

  def checking_path_horizontal?(king_square, checking_piece)
    return true if king_square[0] == checking_piece.current_square[0]

    false
  end

  def checking_path_vertical?(king_square, checking_piece)
    return true if king_square[1] == checking_piece.current_square[1]

    false
  end

  def horizontal_checking_path(king_square, checking_piece)
    row = king_square[0]
    checking_piece_col = checking_piece.current_square[1]
    checking_path = []
    if king_square[1] < checking_piece_col
      while king_square[1] < (checking_piece_col - 1)
        checking_piece_col -= 1
        checking_path.push([row, checking_piece_col])
      end
    else
      while king_square[1] > checking_piece_col + 1
        checking_piece_col += 1
        checking_path.push([row, checking_piece_col])
      end
    end
    checking_path
  end

  def vertical_checking_path(king_square, checking_piece)
    col = king_square[1]
    checking_piece_row = checking_piece.current_square[0]
    checking_path = []
    if king_square[0] < checking_piece_row
      while king_square[0] < (checking_piece_row - 1)
        checking_piece_row -= 1
        checking_path.push([checking_piece_row, col])
      end
    else
      while king_square[0] > (checking_piece_row + 1)
        checking_piece_row += 1
        checking_path.push([checking_piece_row, col])
      end
    end
    checking_path
  end

  def diagonal_up_right_checking_path(king_square, checking_piece)
    king_row = king_square[0]
    checking_piece_row = checking_piece.current_square[0]
    checking_piece_col = checking_piece.current_square[1]
    checking_path = []
    while king_row > (checking_piece_row + 1)
      checking_piece_row += 1
      checking_piece_col -= 1
      checking_path.push([checking_piece_row, checking_piece_col])
    end
    checking_path
  end

  def diagonal_up_left_checking_path(king_square, checking_piece)
    king_row = king_square[0]
    checking_piece_row = checking_piece.current_square[0]
    checking_piece_col = checking_piece.current_square[1]
    checking_path = []
    while king_row > (checking_piece_row + 1)
      checking_piece_row += 1
      checking_piece_col += 1
      checking_path.push([checking_piece_row, checking_piece_col])
    end
    checking_path
  end

  def diagonal_down_left_checking_path(king_square, checking_piece)
    king_row = king_square[0]
    checking_piece_row = checking_piece.current_square[0]
    checking_piece_col = checking_piece.current_square[1]
    checking_path = []
    while king_row < (checking_piece_row - 1)
      checking_piece_row -= 1
      checking_piece_col += 1
      checking_path.push([checking_piece_row, checking_piece_col])
    end
    checking_path
  end

  def diagonal_down_right_checking_path(king_square, checking_piece)
    king_row = king_square[0]
    checking_piece_row = checking_piece.current_square[0]
    checking_piece_col = checking_piece.current_square[1]
    checking_path = []
    while king_row < (checking_piece_row - 1)
      checking_piece_row -= 1
      checking_piece_col -= 1
      checking_path.push([checking_piece_row, checking_piece_col])
    end
    checking_path
  end

  def checking_path_diagonal?(king_square, checking_piece)
    if king_square[0] != checking_piece.current_square[0] && king_square[1] != checking_piece.current_square[1]
      return true
    end

    false
  end

  def checking_path_diagonal_up_right?(king_square, checking_piece)
    if king_square[0] > checking_piece.current_square[0] && king_square[1] < checking_piece.current_square[1]
      return true
    end

    false
  end

  def checking_path_diagonal_up_left?(king_square, checking_piece)
    if king_square[0] > checking_piece.current_square[0] && king_square[1] > checking_piece.current_square[1]
      return true
    end

    false
  end

  def checking_path_diagonal_down_right?(king_square, checking_piece)
    if king_square[0] < checking_piece.current_square[0] && king_square[1] < checking_piece.current_square[1]
      return true
    end

    false
  end

  def checking_path_diagonal_down_left?(king_square, checking_piece)
    if king_square[0] < checking_piece.current_square[0] && king_square[1] > checking_piece.current_square[1]
      return true
    end

    false
  end
end
