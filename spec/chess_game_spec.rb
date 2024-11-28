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
        valid_move = "d3"
        game.send(:create_moves_for_pieces)
        expect(game.valid_move?(selected_piece, valid_move)).to be true
      end
    end
    context "when a invalid move is entered for white" do
      it "returns true" do
        selected_piece = game.board[6][3]
        invalid_move = "h1"
        game.send(:create_moves_for_pieces)
        expect(game.valid_move?(selected_piece, invalid_move)).to be false
      end
    end
  end
  describe "#play_round" do
    context "at the start of the game" do
      before do
        selected_square = "e2"
        selected_move = "e4"
        allow(game).to receive(:gets).and_return(selected_square, selected_move)
      end
      it "moves the correct piece to the correct square" do
        game.send(:play_round)
        old_position = game.move_logic.chess_notation_to_square("e2")
        new_position = game.move_logic.chess_notation_to_square("e4")
        expect(new_position).to be_a(Pawn)
        expect(old_position).to eq(" ")
      end
    end
  end
end
