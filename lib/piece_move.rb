require_relative "board"
require "pry-byebug"

class PieceMove
  attr_reader :board_obj, :board

  def initialize
    @board_obj = Board.new
    @board = @board_obj.board
    @board_obj.fill_board
    @king_squares = []
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
        piece_on_square.create_possible_moves if piece_on_square != " "
      end
    end
  end

  def clear_moves
    (0..7).each do |row|
      (0..7).each do |col|
        piece_on_square = board[row][col]
        piece_on_square.possible_moves.clear if piece_on_square != " "
      end
    end
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
        @king_squares.push([row, col]) if piece_on_square != " " && piece_on_square.is_a?(King)
      end
    end
  end

  def remove_diagonal_up_left(row, col, piece)
    while square_in_bounds?(row - 1, col - 1) && @board[row - 1][col - 1] == " "
      row -= 1
      col -= 1
    end
    blocked = true if @board[row - 1][col - 1].color == piece.color
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
    @board[old_square[0]][old_square[1]] = " "
    @board[new_square[0]][new_square[1]] = piece
    piece.current_square[new_square[0], new_square[1]]
  end

  def square_in_bounds?(row, col)
    return true if row.between?(0, 7) && col.between?(0, 7)

    false
  end
end
