class Pawn
  def initialize
  end

  def self.starting_range?(row, col)
    starting_rows = [1, 6]
    starting_cols = (0..7)
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end
end
