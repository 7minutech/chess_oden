require_relative "piece_move"
class ChessGame
  def initialize
    @move_logic = PieceMove.new
    @color_turn = :white
    @board = @move_logic.board_obj.board
  end

  def flip_player_turn
    @color_turn = if @color_turn == :white
                    :black
                  else
                    :white
                  end
  end

  def valid_piece_input
    square = piece_input
    until valid_piece?(square)
      puts "#{square} is not valid, please enter a valid move"
      piece_input
    end
  end

  def valid_piece?(square)
    selected_square = PieceMove.convert_chess_notation(square)
    selected_piece = @board[selected_square[0]][selected_square[1]]
    return true if selected_piece != " " && selected_piece.color == @color_turn

    false
  end

  def piece_input
    print "Select the square of the piece you'd like to move: "
    get.chomp
  end
end
