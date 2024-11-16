require_relative "../lib/board"
describe Board do
  let(:chess_board) { described_class.new }
  describe "#display_baord" do
    before do
      (0..7).each do |file|
        chess_board.board[0][file] = "\u265A"
        chess_board.board[1][file] = "\u265F"
        chess_board.board[6][file] = "\u2659"
        chess_board.board[7][file] = "\u2654"
      end
    end
    it "prints chess board" do
      chess_board.send(:display_board)
    end
  end
end
