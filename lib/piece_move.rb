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
    temp_row = row
    temp_col = col
    while (temp_row - 1).between?(0, 7) && (temp_col - 1).between?(0, 7) && @board[temp_row - 1][temp_col - 1] == " "
      temp_row -= 1
      temp_col -= 1
    end
    while (temp_row - 1).between?(0, 7) && (temp_col - 1).between?(0, 7)
      temp_row -= 1
      temp_col -= 1
      piece.possible_moves.delete([temp_row, temp_col])
    end
    temp_row = row
    temp_col = col
    while (temp_row - 1).between?(0, 7) && (temp_col + 1).between?(0, 7) && @board[temp_row - 1][temp_col + 1] == " "
      temp_row -= 1
      temp_col += 1
    end
    while (temp_row - 1).between?(0, 7) && (temp_col + 1).between?(0, 7)
      temp_row -= 1
      temp_col += 1
      piece.possible_moves.delete([temp_row, temp_col])
    end
    temp_row = row
    temp_col = col
    while (temp_row + 1).between?(0, 7) && (temp_col - 1).between?(0, 7) && @board[temp_row + 1][temp_col - 1] == " "
      temp_row += 1
      temp_col -= 1
    end
    while (temp_row + 1).between?(0, 7) && (temp_col - 1).between?(0, 7)
      temp_row += 1
      temp_col -= 1
      piece.possible_moves.delete([temp_row, temp_col])
    end
    temp_row = row
    temp_col = col
    while (temp_row + 1).between?(0, 7) && (temp_col + 1).between?(0, 7) && @board[temp_row + 1][temp_col + 1] == " "
      temp_row += 1
      temp_col += 1
    end
    while (temp_row + 1).between?(0, 7) && (temp_col + 1).between?(0, 7)
      temp_row += 1
      temp_col += 1
      piece.possible_moves.delete([temp_row, temp_col])
    end
  end
end
