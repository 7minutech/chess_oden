require_relative "../lib/piece_move"
require "pry-byebug"

describe PieceMove do
  let(:piece_move) { described_class.new }
  describe "#pawn_moves" do
    context "at the start of the game" do
      it "sets the correct possibles for pawns" do
        board = piece_move.board_obj.board
        piece_move.pawn_moves
        a2 = board[6][0]
        a7 = board[1][0]
        b2 = board[6][1]
        b7 = board[1][1]
        expect(a2.possible_moves).to include([5, 0], [4, 0])
        expect(a7.possible_moves).to include([2, 0], [3, 0])
        expect(b2.possible_moves).to include([5, 1], [4, 1])
        expect(b7.possible_moves).to include([2, 1], [3, 1])
      end
    end
  end
end
