class Knight
  def initialize
  end

  def self.starting_range?(row, col)
    starting_rows = [0, 7]
    starting_cols = [1, 6]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end
end
