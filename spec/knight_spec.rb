require_relative "../lib/pieces/bishop"

describe Bishop do
  describe "#create_possible_moves" do
    context "when knight is in the middle of the board" do
      subject(:d4_white_knight) { described_class.new(:white, [4, 3]) }
      it "creates list of possible moves" do
        d4_white_knight.create_possible_moves
        expect(d4_white_knight.possible_moves).to include([2, 2], [6, 2], [2, 4], [6, 4],
                                                          [3, 1], [5, 1], [3, 5], [5, 5])
      end
    end
  end
end
