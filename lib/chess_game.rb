require_relative "piece_move"
class ChessGame
  attr_accessor :board, :move_logic

  def initialize
    @move_logic = PieceMove.new
    @color_turn = :white
    @board = @move_logic.board_obj.board
    @selected_square = nil
    @selected_next_square = nil
    @turns = 0
    @draw = false
    @positions = {}
  end

  def flip_player_turn
    @color_turn = if @color_turn == :white
                    :black
                  else
                    :white
                  end
  end

  def add_position
    if @positions[@board]
      @positions[@board] += 1
    else
      @positions[@board] = 1
    end
  end

  def threefold_repetition?
    @positions.each_value do |value|
      return true if value >= 3
    end
    false
  end

  def threefold_repetition
    @draw = true if threefold_repetition?
  end

  def draw?
    @draw == true
  end

  def king_v_king?
    return true if @move_logic.white_pieces.length == 1 && @move_logic.black_pieces.length == 1

    false
  end

  def king_v_bishop?
    white_pieces = @move_logic.white_pieces
    black_pieces = @move_logic.black_pieces
    white_bishop = white_pieces.any? { |piece| piece.is_a?(Bishop) }
    black_bishop = black_pieces.any? { |piece| piece.is_a?(Bishop) }
    return true if (white_pieces.length == 2 && white_bishop) && black_pieces.length == 1
    return true if (black_pieces.length == 2 && black_bishop) && white_pieces.length == 1

    false
  end

  def king_v_knight
    white_pieces = @move_logic.white_pieces
    black_pieces = @move_logic.black_pieces
    white_bishop = white_pieces.any? { |piece| piece.is_a?(Knight) }
    black_bishop = black_pieces.any? { |piece| piece.is_a?(Knight) }
    return true if (white_pieces.length == 2 && white_bishop) && black_pieces.length == 1
    return true if (black_pieces.length == 2 && black_bishop) && white_pieces.length == 1

    false
  end

  def insufficient_material?
    @draw = true if king_v_king? || king_v_bishop? || king_v_knight
  end

  def draw_offer(offer)
    return unless offer == "draw"

    puts "#{@color_turn} offered a draw"
    puts "Enter a:accept or d:decline"
    answer = gets.chomp.downcase
    return unless answer == "a"

    @draw = true
  end

  def valid_piece_input
    square = piece_input
    until valid_piece?(square)
      puts "#{square} is not valid, please enter a valid move"
      square = piece_input
    end
    puts "\nSelected Square: #{square}"
    return if draw?

    translated_move = PieceMove.convert_chess_notation(square)
    @selected_square = @board[translated_move[0]][translated_move[1]]
    @board[translated_move[0]][translated_move[1]]
  end

  def square_in_range?(square)
    row = square[0]
    col = square[1]
    return true if row.between?(0, 7) && col.between?(0, 7)

    false
  end

  def valid_piece?(square)
    draw_offer(square)
    unless draw?
      return false if square == "draw"
      return false unless square.length == 2

      selected_square = PieceMove.convert_chess_notation(square)
      return false unless square_in_range?(selected_square)

      selected_piece = @board[selected_square[0]][selected_square[1]]
      return true if selected_piece != " " && selected_piece.color == @color_turn
    end
    return true if draw?

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
    # binding.pry
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
    if @turns.zero?
      @move_logic.create_possible_moves
      @move_logic.board_obj.display_board
    end
    valid_piece_input
    return if draw?

    valid_move_input
    @move_logic.move_piece([@selected_square.current_square[0], @selected_square.current_square[1]],
                           [@selected_next_square[0], @selected_next_square[1]])
    insufficient_material?
    add_position
    threefold_repetition
    @move_logic.board_obj.display_board
    flip_player_turn
    @turns += 1
  end

  def checkmate?
    if @move_logic.check?
      if @color_turn == :black
        @move_logic.remove_illegal_moves_in_check(:black)
        return true if @move_logic.black_king.possible_moves.empty? && !@move_logic.legal_moves?(:black)
      else
        @move_logic.remove_illegal_moves_in_check(:white)
        return true if @move_logic.white_king.possible_moves.empty? && !@move_logic.legal_moves?(:white)
      end
    end
    false
  end

  def play_game
    play_round until checkmate? || draw?
    puts "Game over"
  end
end
