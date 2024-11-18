require_relative "board"

class PieceMove
  attr_reader :board_obj

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

  def pawn_moves
    @board.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        piece = @board[row_index][col_index]
        if piece.is_a?(Pawn)
          if piece.color == :white
            piece.possible_moves.push([row_index - 2, col_index]) if piece.current_square == piece.starting_square
            piece.possible_moves.push([row_index - 1, col_index])
          else
            piece.possible_moves.push([row_index + 2, col_index]) if piece.current_square == piece.starting_square
            piece.possible_moves.push([row_index + 1, col_index])
          end
        end
      end
    end
  end
end
