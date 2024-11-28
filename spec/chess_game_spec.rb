require_relative "../lib/chess_game"

describe ChessGame do
  let(:game) { described_class }
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
        allow(:game).to receive(:puts).with(prompt_message).twice
        expect(:game).not_to receive(:puts).with(error_message)
        game.send(:valid_move).twice
      end
    end
  end
end
