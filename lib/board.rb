require "pry-byebug"
require "rainbow"
Dir[File.join(__dir__, "pieces", "*.rb")].sort.each { |file| require file }

# Describes a chess board
class Board
  attr_accessor :board

  WHITE_BACKGROUND = "ffffff".freeze
  GREEN_BACKGROUND = "6a9b41".freeze
  def initialize
    @board = Array.new(8) { Array.new(8) { " " } }
  end

  def display_board
    print "  "
    (97..104).each { |num| print " #{num.chr} " }
    count = 8
    print "\n"
    @board.each_with_index do |row, row_index|
      print "#{count} "
      row.each_with_index do |col, col_index|
        if (row_index + col_index).even?
          display_background(col, WHITE_BACKGROUND)
        else
          display_background(col, GREEN_BACKGROUND)
        end
      end
      print "\n"
      count -= 1
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
        place_starting_rooks(row, col)
        place_starting_knights(row, col)
        place_starting_bishops(row, col)
        place_starting_queens(row, col)
        place_starting_kings(row, col)
        place_starting_pawns(row, col)
      end
    end
  end

  def place_starting_rooks(row, col)
    return unless Rook.starting_range?(row, col)

    @board[row][col] = if Rook.starting_range_black?(row, col)
                         Rook.new(:black)
                       else
                         Rook.new(:white)
                       end
  end

  def place_starting_knights(row, col)
    return unless Knight.starting_range?(row, col)

    @board[row][col] = if Knight.starting_range_black?(row, col)
                         Knight.new(:black)
                       else
                         Knight.new(:white)
                       end
  end

  def place_starting_bishops(row, col)
    return unless Bishop.starting_range?(row, col)

    @board[row][col] = if Bishop.starting_range_black?(row, col)
                         Bishop.new(:black)
                       else
                         Bishop.new(:white)
                       end
  end

  def place_starting_queens(row, col)
    return unless Queen.starting_range?(row, col)

    @board[row][col] = if Queen.starting_range_black?(row, col)
                         Queen.new(:black)
                       else
                         Queen.new(:white)
                       end
  end

  def place_starting_kings(row, col)
    return unless King.starting_range?(row, col)

    @board[row][col] = if King.starting_range_black?(row, col)
                         King.new(:black)
                       else
                         King.new(:white)
                       end
  end

  def place_starting_pawns(row, col)
    return unless Pawn.starting_range?(row, col)

    @board[row][col] = if Pawn.starting_range_black?(row, col)
                         Pawn.new(:black)
                       else
                         Pawn.new(:white)
                       end
  end
end
