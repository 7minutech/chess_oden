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
  describe "#fill_board" do
    before do
      chess_board.send(:fill_board)
    end
    it "fills board with chess pieces" do
      expected_positions = {
        # White major pieces
        [0, 0] => Rook, [0, 1] => Knight, [0, 2] => Bishop, [0, 3] => Queen, [0, 4] => King,
        [0, 5] => Bishop, [0, 6] => Knight, [0, 7] => Rook,

        # Black major pieces
        [7, 0] => Rook, [7, 1] => Knight, [7, 2] => Bishop, [7, 3] => Queen, [7, 4] => King,
        [7, 5] => Bishop, [7, 6] => Knight, [7, 7] => Rook,

        # White pawns
        [1, 0] => Pawn, [1, 1] => Pawn, [1, 2] => Pawn, [1, 3] => Pawn,
        [1, 4] => Pawn, [1, 5] => Pawn, [1, 6] => Pawn, [1, 7] => Pawn,

        # Black pawns
        [6, 0] => Pawn, [6, 1] => Pawn, [6, 2] => Pawn, [6, 3] => Pawn,
        [6, 4] => Pawn, [6, 5] => Pawn, [6, 6] => Pawn, [6, 7] => Pawn
      }

      expected_positions.each do |(row, col), piece_class|
        expect(chess_board.board[row][col]).to be_a(piece_class)
      end
    end
  end
end
