class Rook
  def initialize
  end

  def self.starting_range?(row, col)
    starting_rows = [0, 7]
    starting_cols = [0, 7]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end
end
