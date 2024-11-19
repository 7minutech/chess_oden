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
  describe "#remove_impossible_pawn_moves" do
    context "at the start of the game" do
      it "removes impossible moves for pawns" do
        board = piece_move.board_obj.board
        e2 = board[6][4]
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to contain_exactly([5, 4], [4, 4])
      end
    end
    context "when a capture is possible" do
      it "removes impossible moves for pawns" do
        board = piece_move.board_obj.board
        d3_black_pawn = Pawn.new(:black, [5, 3])
        e2 = board[6][4]
        board[5][3] = d3_black_pawn
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to contain_exactly([5, 4], [4, 4], [5, 3])
      end
    end
    context "when a piece is blocking its path one square up" do
      it "removes impossible moves for pawns" do
        board = piece_move.board_obj.board
        board[5][4] = Pawn.new
        e2 = board[6][4]
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to be_empty
      end
    end
    context "when a piece is blocking its path two squares up" do
      it "removes impossible moves for pawns" do
        board = piece_move.board_obj.board
        board[6][4] = Pawn.new
        e2 = board[6][4]
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to contain_exactly([5, 4])
      end
    end
  end
end
