require_relative "../lib/piece_move"
require "pry-byebug"

describe PieceMove do
  let(:piece_move) { described_class.new }
  describe "#convert_chess_notation" do
    it "takes a chess notation and converts it to an corresponding array" do
      a2 = PieceMove.convert_chess_notation("a2")
      d4 = PieceMove.convert_chess_notation("d4")
      f6 = PieceMove.convert_chess_notation("f6")
      expect(a2).to eq([6, 0])
      expect(d4).to eq([4, 3])
      expect(f6).to eq([2, 5])
    end
  end
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
