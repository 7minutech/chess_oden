class Pawn
  attr_accessor :color, :current_square, :possible_moves
  attr_reader :starting_square

  def initialize(color = nil, current_square = nil)
    @color = color
    @current_square = current_square
    @starting_square = current_square
    @possible_moves = []
  end

  def self.starting_range?(row, col)
    starting_rows = [1, 6]
    starting_cols = (0..7)
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end

  def moved?
    return true if @starting_square != @current_square

    false
  end

  def to_s
    if @color == :white
      "\u2659"
    else
      "\u265F"
    end
  end

  def self.starting_range_black?(row, col)
    starting_rows = [1]
    starting_cols = (0..7)
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end

  def self.starting_range_white?(row, col)
    starting_rows = [6]
    starting_cols = (0..7)
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end
end
