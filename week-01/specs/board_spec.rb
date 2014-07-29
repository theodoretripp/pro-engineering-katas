require_relative '../board'

describe Board do
  subject(:board) { Board.new(5,3) }

  it { is_expected.to respond_to(:row_count).with(0).arguments }
  it { is_expected.to respond_to(:column_count).with(0).arguments }
  it { is_expected.to respond_to(:get).with(2).arguments }
  it { is_expected.to respond_to(:place).with(3).arguments }
  it { is_expected.to respond_to(:remove).with(2).arguments }

  describe '.new' do
    context 'when dimensions are valid' do
      it 'returns an instance of Board' do
        board = Board.new(5,3)
        expect(board).to be_instance_of(Board)
      end
    end

    context 'when dimensions are not positive' do
      it 'raises a DimensionError on row' do
        expect {
          Board.new(0,10)
        }.to raise_error(Board::DimensionError)
      end

      it 'raises a DimensionError on column' do
        expect {
          Board.new(10,0)
        }.to raise_error(Board::DimensionError)
      end
    end
  end

  describe '#row_count' do
    it 'returns the number of rows on the board' do
      board = Board.new(5,3)
      expect(board.row_count).to eq(5)
    end
  end

  describe '#column_count' do
    it 'returns the number of columns on the board' do
      board = Board.new(5,3)
      expect(board.column_count).to eq(3)
    end
  end

  describe '#get' do
    let(:board) { Board.new(5,3) }

    context 'when dimensions are valid' do
      it 'returns nil if cell is empty' do
        expect(board.get(0,0)).to eq(nil)
      end

      it 'returns the value of the specified cell' do
        board.place(0,0,'X')
        expect(board.get(0,0)).to eq('X')
      end
    end

    context 'when dimensions are too large' do
      it 'raises a DimensionError on row' do
        expect {
          board.get(board.row_count, 0)
        }.to raise_error(Board::DimensionError)
      end

      it 'raises a DimensionError on column' do
        expect {
          board.get(0, board.column_count)
        }.to raise_error(Board::DimensionError)
      end
    end
  end

  describe '#place' do
    let(:board) { Board.new(5,3) }

    context 'when dimensions are valid' do
      it 'sets the value of the specified cell' do
        expect {
          board.place(0,0,'X')
        }.to change { board.get(0,0) }.from(nil).to('X')
      end

      it 'raises a CellError if cell is already occupied' do
        expect {
          board.place(0,0,'X')
          board.place(0,0,'X')
        }.to raise_error(Board::CellError)
      end
    end

    context 'when dimensions are too large' do
      it 'raises a DimensionError on row' do
        expect {
          board.place(board.row_count, 0, 'X')
        }.to raise_error(Board::DimensionError)
      end

      it 'raises a DimensionError on column' do
        expect {
          board.place(0, board.column_count, 'X')
        }.to raise_error(Board::DimensionError)
      end
    end
  end

  describe '#remove' do
    let(:board) { Board.new(5,3) }

    context 'when dimensions are valid' do
      it 'removes the value from the specified cell' do
        board.place(0,0,'X')

        expect {
          board.remove(0,0)
        }.to change { board.get(0,0) }.from('X').to(nil)
      end

      it 'raises a CellError if cell is already empty' do
        expect {
          board.remove(0,0)
        }.to raise_error(Board::CellError)
      end
    end

    context 'when dimensions are too large' do
      it 'raises a DimensionError on row' do
        expect {
          board.remove(board.row_count, 0)
        }.to raise_error(Board::DimensionError)
      end

      it 'raises a DimensionError on column' do
        expect {
          board.remove(0, board.column_count)
        }.to raise_error(Board::DimensionError)
      end
    end
  end
end
