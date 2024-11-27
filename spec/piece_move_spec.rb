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
      it "removes impossible moves for pawns for white" do
        board = piece_move.board_obj.board
        e2 = board[6][4]
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to contain_exactly([5, 4], [4, 4])
      end
      it "removes impossible moves for pawns for black" do
        board = piece_move.board_obj.board
        e7 = board[1][4]
        e7.create_possible_moves
        piece_move.remove_impossible_pawn_moves(1, 4)
        expect(e7.possible_moves).to contain_exactly([2, 4], [3, 4])
      end
    end
    context "when a capture is possible" do
      it "removes impossible moves for white pawns" do
        board = piece_move.board_obj.board
        d3_black_pawn = Pawn.new(:black, [5, 3])
        e2 = board[6][4]
        board[5][3] = d3_black_pawn
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to contain_exactly([5, 4], [4, 4], [5, 3])
      end
      it "removes impossible moves for black pawns" do
        board = piece_move.board_obj.board
        d5_white_pawn = Pawn.new(:white, [2, 3])
        e7 = board[1][4]
        board[2][3] = d5_white_pawn
        e7.create_possible_moves
        piece_move.remove_impossible_pawn_moves(1, 4)
        expect(e7.possible_moves).to contain_exactly([2, 4], [3, 4], [2, 3])
      end
    end
    context "when a piece is blocking its path one square up" do
      it "removes impossible moves for white pawns" do
        board = piece_move.board_obj.board
        board[5][4] = Pawn.new
        e2 = board[6][4]
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to be_empty
      end
      it "removes impossible moves for black pawns" do
        board = piece_move.board_obj.board
        board[2][4] = Pawn.new
        e7 = board[1][4]
        e7.create_possible_moves
        piece_move.remove_impossible_pawn_moves(1, 4)
        expect(e7.possible_moves).to be_empty
      end
    end
    context "when a piece is blocking its path two squares up" do
      it "removes impossible moves for white pawns" do
        board = piece_move.board_obj.board
        board[4][4] = Pawn.new
        e2 = board[6][4]
        e2.create_possible_moves
        piece_move.remove_impossible_pawn_moves(6, 4)
        expect(e2.possible_moves).to contain_exactly([5, 4])
      end
      it "removes impossible moves for black pawns" do
        board = piece_move.board_obj.board
        board[3][4] = Pawn.new
        e7 = board[1][4]
        e7.create_possible_moves
        piece_move.remove_impossible_pawn_moves(1, 4)
        expect(e7.possible_moves).to contain_exactly([2, 4])
      end
    end
  end

  describe "#remove_impossible_bishop_moves" do
    let(:board) { piece_move.board }
    context "at the start of the game" do
      it "removes impossible moves for white light squared bishop" do
        white_light_squared_bishop = board[7][5]
        piece_move.remove_impossible_bishop_moves(7, 5)
        expect(white_light_squared_bishop.possible_moves).to be_empty
      end
      it "removes impossible moves for white dark squared bishop" do
        white_dark_squared_bishop = board[7][2]
        piece_move.remove_impossible_bishop_moves(7, 2)
        expect(white_dark_squared_bishop.possible_moves).to be_empty
      end
      it "removes impossible moves for black light squared bishop" do
        black_light_squared_bishop = board[0][5]
        piece_move.remove_impossible_bishop_moves(0, 5)
        expect(black_light_squared_bishop.possible_moves).to be_empty
      end
      it "removes impossible moves for black dark squared bishop" do
        black_dark_squared_bishop = board[0][2]
        piece_move.remove_impossible_bishop_moves(0, 2)
        expect(black_dark_squared_bishop.possible_moves).to be_empty
      end
    end
    context "when the bishop is at the center" do
      it "removes the impossible moves for bishop" do
        bishop = Bishop.new(:white, [4, 3])
        board[4][3] = bishop
        piece_move.remove_impossible_bishop_moves(4, 3)
        expect(bishop.possible_moves).to contain_exactly([5, 4], [5, 2], [3, 4], [3, 2], [2, 3], [2, 5])
      end
    end
  end
end
