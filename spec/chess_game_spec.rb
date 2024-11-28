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
  describe "#valid_move" do
    context "when a valid move is entered for white" do
      before do
        valid_move1 = "e4"
        valid_move2 = "d3"
        allow(game).to receive(:gets).and_return(valid_move1, valid_move2)
      end
      it "returns no error message" do
        prompt_message = "Enter your move: "
        error_message = "That is not a valid move please enter a valid"
        allow(game).to receive(:puts).with(prompt_message).twice
        expect(game).not_to receive(:puts).with(error_message)
        game.send(:valid_move).twice
      end
    end
  end
end
