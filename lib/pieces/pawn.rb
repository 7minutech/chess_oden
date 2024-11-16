class Pawn
  attr_reader :color

  def initialize(color = nil)
    @color = color
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
