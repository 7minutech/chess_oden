require_relative "../lib/chess_game"

describe ChessGame do
  let(:game) { described_class.new }
  describe "#valid_piece?" do
    context "when a valid square is entered for white" do
      it "returns true" do
        valid_move1 = "e2"
        valid_move2 = "a1"
        expect(game.valid_piece?(valid_move1)).to be true
        expect(game.valid_piece?(valid_move2)).to be true
      end
    end
    context "when a invalid square is entered for white" do
      it "returns true" do
        valid_move1 = "e4"
        valid_move2 = "a4"
        expect(game.valid_piece?(valid_move1)).to be false
        expect(game.valid_piece?(valid_move2)).to be false
      end
    end
    context "when a valid square is entered for black" do
      it "returns true" do
        valid_move1 = "f8"
        valid_move2 = "h7"
        game.send(:flip_player_turn)
        expect(game.valid_piece?(valid_move1)).to be true
        expect(game.valid_piece?(valid_move2)).to be true
      end
    end
    context "when a invalid square is entered for black" do
      it "returns true" do
        valid_move1 = "f4"
        valid_move2 = "h2"
        game.send(:flip_player_turn)
        expect(game.valid_piece?(valid_move1)).to be false
        expect(game.valid_piece?(valid_move2)).to be false
      end
    end
  end
  describe "#valid_move?" do
    context "when a valid move is entered for white" do
      it "returns true" do
        selected_piece = game.board[6][3]
        valid_move = [5, 3]
        expect(game.valid_move?(selected_piece, valid_move)).to be true
      end
    end
    context "when a invalid move is entered for white" do
      it "returns true" do
        selected_piece = game.board[6][3]
        valid_move = [1, 3]
        expect(game.valid_move?(selected_piece, valid_move)).to be false
      end
    end
  end
end
