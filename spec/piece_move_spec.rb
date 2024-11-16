require_relative "../lib/piece_move"

describe PieceMove do
  let(:piece_move) { described_class.new }
  describe "#piece_current_sqaure" do
    before do
      board = piece_move.board_obj
      board.fill_board
    end
    it "sets the current squares" do
      board = piece_move.board_obj.board
      staring_rows = [0, 1, 6, 7]
      board.each_with_index do |row, row_index|
        row.each_index do |col_index|
          if staring_rows.include?(row_index)
            expect(board[row_index][col_index]).current_square.to eq([row_index, col_index])
          end
        end
      end
    end
  end
end
