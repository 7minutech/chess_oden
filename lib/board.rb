require "rainbow"

class Board
  attr_accessor :board

  WHITE_BACKGROUND = "ebecd0".freeze
  GREEN_BACKGROUND = "739552".freeze
  def initialize
    @board = Array.new(8) { Array.new(8) { " " } }
  end

  def display_board
    count = 0
    @board.each do |row|
      row.each do |col|
        if count.even?
          display_background(col, WHITE_BACKGROUND)
        else
          display_background(col, GREEN_BACKGROUND)
        end
        count += 1
      end
      print "\n"
      count += 1
    end
  end

  def display_background(square, background)
    print Rainbow(" ").background(background)
    print Rainbow(square).background(background)
    print Rainbow(" ").background(background)
  end
end
