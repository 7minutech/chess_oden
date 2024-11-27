require_relative "board"
require "pry-byebug"

class PieceMove
  attr_reader :board_obj, :board

  def initialize
    @board_obj = Board.new
    @board = @board_obj.board
    @board_obj.fill_board
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
    piece.possible_moves.each do |move|
      piece_on_move = board[move[0]][move[1]]
      piece.possible_moves.delete(move) if piece_on_move != " " && piece_on_move.color == piece.color
    end
  end

  def remove_diagonal_up_left(row, col, piece)
    while (row - 1).between?(0, 7) && (col - 1).between?(0, 7) && @board[row - 1][col - 1] == " "
      row -= 1
      col -= 1
    end
    blocked = true if @board[row - 1][col - 1].color == piece.color
    opposite_piece_found = 0
    while (row - 1).between?(0, 7) && (col - 1).between?(0, 7)
      row -= 1
      col -= 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_diagonal_up_right(row, col, piece)
    while (row - 1).between?(0, 7) && (col + 1).between?(0, 7) && @board[row - 1][col + 1] == " "
      row -= 1
      col += 1
    end
    blocked = true if @board[row - 1][col + 1].color == piece.color

    opposite_piece_found = 0
    while (row - 1).between?(0, 7) && (col + 1).between?(0, 7)
      row -= 1
      col += 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_diagonal_down_left(row, col, piece)
    # binding.pry
    while (row + 1).between?(0, 7) && (col - 1).between?(0, 7) && @board[row + 1][col - 1] == " "
      row += 1
      col -= 1
    end
    if ((row + 1).between?(0, 7) && (col - 1).between?(0, 7)) && @board[row + 1][col - 1].color == piece.color
      blocked = true
    end
    opposite_piece_found = 0
    while (row + 1).between?(0, 7) && (col - 1).between?(0, 7)
      row += 1
      col -= 1
      opposite_piece_found += 1 if @board[row][col] != " " && @board[row][col].color != piece.color
      piece.possible_moves.delete([row, col]) unless opposite_piece_found == 1 && @board[row][col] != " " && !blocked
    end
  end

  def remove_diagonal_down_right(row, col, piece)
    while (row + 1).between?(0, 7) && (col + 1).between?(0, 7) && @board[row + 1][col + 1] == " "
      row += 1
      col += 1
    end
    if ((row + 1).between?(0, 7) && (col + 1).between?(0, 7)) && @board[row + 1][col + 1].color == piece.color
      blocked = true
    end
    opposite_piece_found = 0
    while (row + 1).between?(0, 7) && (col + 1).between?(0, 7)
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
end
