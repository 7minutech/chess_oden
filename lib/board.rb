require "pry-byebug"
require "rainbow"
Dir[File.join(__dir__, "pieces", "*.rb")].sort.each { |file| require file }

class Board
  attr_accessor :board

  WHITE_BACKGROUND = "ebecd0".freeze
  GREEN_BACKGROUND = "739552".freeze
  def initialize
    @board = Array.new(8) { Array.new(8) { " " } }
  end

  def display_board
    @board.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        if (row_index + col_index).even?
          display_background(col, WHITE_BACKGROUND)
        else
          display_background(col, GREEN_BACKGROUND)
        end
      end
      print "\n"
    end
  end

  def display_background(square, background)
    print Rainbow(" ").background(background)
    print Rainbow(square).background(background)
    print Rainbow(" ").background(background)
  end

  def fill_board
    @board.each_index do |row|
      @board.each_index do |col|
        @board[row][col] = Rook.new(:black) if Rook.starting_range_black?(row, col)
        @board[row][col] = Rook.new(:white) if Rook.starting_range_white?(row, col)

        @board[row][col] = Knight.new(:black) if Knight.starting_range_black?(row, col)
        @board[row][col] = Knight.new(:white) if Knight.starting_range_white?(row, col)

        @board[row][col] = Bishop.new(:black) if Bishop.starting_range_black?(row, col)
        @board[row][col] = Bishop.new(:white) if Bishop.starting_range_white?(row, col)

        @board[row][col] = Queen.new(:black) if Queen.starting_range_black?(row, col)
        @board[row][col] = Queen.new(:white) if Queen.starting_range_white?(row, col)

        @board[row][col] = King.new(:black) if King.starting_range_black?(row, col)
        @board[row][col] = King.new(:white) if King.starting_range_white?(row, col)

        @board[row][col] = Pawn.new(:black) if Pawn.starting_range_black?(row, col)
        @board[row][col] = Pawn.new(:white) if Pawn.starting_range_white?(row, col)
      end
    end
  end
end
