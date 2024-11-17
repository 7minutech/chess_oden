require_relative "board"

class PieceMove
  attr_reader :board_obj

  def initialize
    @board_obj = Board.new
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
end
