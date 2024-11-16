require_relative "board"

class PieceMove
  attr_reader :board_obj

  def initialize
    @board_obj = Board.new
    @board_obj.fill_board
  end
end
