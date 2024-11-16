class Bishop
  attr_accessor :color, :current_square

  def initialize(color = nil, current_square = nil)
    @color = color
    @current_square = current_square
  end

  def to_s
    if @color == :white
      "\u2657"
    else
      "\u265D"
    end
  end

  def self.starting_range?(row, col)
    starting_rows = [0, 7]
    starting_cols = [2, 5]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end

  def self.starting_range_black?(row, col)
    starting_rows = [0]
    starting_cols = [2, 5]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end

  def self.starting_range_white?(row, col)
    starting_rows = [7]
    starting_cols = [2, 5]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end
end
