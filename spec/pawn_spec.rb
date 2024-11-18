require_relative "../lib/pieces/pawn"

describe Pawn do
  describe "#create_possible_moves" do
    context "at the start of the game for white" do
      subject(:start_white_pawn_a2) { described_class.new(:white, [6, 0]) }
      subject(:start_white_pawn_e2) { described_class.new(:white, [6, 3]) }
      it "creates list of possible moves" do
        start_white_pawn_a2.create_possible_moves
        start_white_pawn_e2.create_possible_moves
        expect(start_white_pawn_a2.possible_moves).to include([5, 0], [4, 0], [5, 1])
        expect(start_white_pawn_e2.possible_moves).to include([5, 3], [4, 3], [5, 2], [5, 4])
      end
    end
  end
end
