class Knight
  attr_reader :color

  def initialize(color = nil)
    @color = color
  end

  def self.starting_range?(row, col)
    starting_rows = [0, 7]
    starting_cols = [1, 6]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end

  def self.starting_range_black?(row, col)
    starting_rows = [0]
    starting_cols = [1, 6]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end

  def self.starting_range_white?(row, col)
    starting_rows = [7]
    starting_cols = [1, 6]
    return true if starting_rows.include?(row) && starting_cols.include?(col)

    false
  end
end
