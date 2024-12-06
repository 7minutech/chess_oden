require_relative "piece_move"
class ChessGame
  attr_accessor :board, :move_logic

  def initialize
    @move_logic = PieceMove.new
    @color_turn = :white
    @board = @move_logic.board_obj.board
    @selected_square = nil
    @selected_next_square = nil
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
      square = piece_input
    end
    puts "\nSelected Square: #{square}"
    translated_move = PieceMove.convert_chess_notation(square)
    @selected_square = @board[translated_move[0]][translated_move[1]]
    @board[translated_move[0]][translated_move[1]]
  end

  def valid_piece?(square)
    selected_square = PieceMove.convert_chess_notation(square)
    selected_piece = @board[selected_square[0]][selected_square[1]]
    return true if selected_piece != " " && selected_piece.color == @color_turn

    false
  end

  def piece_input
    print "Select the square of the piece you'd like to move: "
    gets.chomp
  end

  def move_input
    print "Select the square where you'd like to move: "
    gets.chomp
  end

  def valid_move?(selected_piece, move)
    translated_move = PieceMove.convert_chess_notation(move)
    return true if selected_piece.possible_moves.include?([translated_move[0], translated_move[1]])

    false
  end

  def valid_move_input
    move = move_input
    until valid_move?(@selected_square, move)
      puts "#{move} is not a valid move"
      move = move_input
    end
    puts "\nSquare to move: #{move}"
    translated_move = PieceMove.convert_chess_notation(move)
    @selected_next_square = [translated_move[0], translated_move[1]]
  end

  def play_round
    @move_logic.create_possible_moves
    valid_piece_input
    valid_move_input
    @move_logic.move_piece([@selected_square.current_square[0], @selected_square.current_square[1]],
                           [@selected_next_square[0], @selected_next_square[1]])
    @move_logic.board_obj.display_board
    flip_player_turn
    @move_logic.clear_moves
  end

  def checkmate?
    if @move_logic.check?
      if @color_turn == :white
        return true if @move_logic.black_king.possible_moves.empty?
      elsif @move_logic.white_king.possible_moves.empty?
        return true
      end
    end
    false
  end
end
