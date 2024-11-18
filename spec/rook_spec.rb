require_relative "../lib/pieces/rook"

describe Rook do
  describe "#create_possible_moves" do
    context "at the start of the game for white" do
      subject(:start_white_rook_a1) { described_class.new(:white, [7, 0]) }
      subject(:start_white_rook_h1) { described_class.new(:white, [7, 7]) }
      it "creates list of possible moves" do
        start_white_rook_a1.create_possible_moves
        start_white_rook_h1.create_possible_moves
        expect(start_white_rook_a1.possible_moves).to include([5, 0], [4, 0], [5, 1])
        expect(start_white_rook_h1.possible_moves).to include([5, 3], [4, 3], [5, 2], [5, 4])
      end
    end
    context "at the start of the game for black" do
      subject(:start_black_rook_a8) { described_class.new(:black, [0, 0]) }
      subject(:start_black_rook_h8) { described_class.new(:black, [0, 7]) }
      it "creates list of possible moves" do
        start_black_rook_a8.create_possible_moves
        start_black_rook_h8.create_possible_moves
        expect(start_black_rook_a8.possible_moves).to include([2, 0], [3, 0], [2, 1])
        expect(start_black_rook_h8.possible_moves).to include([2, 3], [3, 3], [2, 2], [2, 4])
      end
    end
  end
end
