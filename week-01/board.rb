# Classes: Board

# Let's write a class that represents a basic grid-based "game board",
# as in chess, checkers, tic-tac-toe, Go, and so on.  This is *only* the board
# and it contains absolutely no game-specific logic.

# The goal of this kata is to build familiarity with RSpec tests and their
# output.  Below it the skeleton of the Board class. Implement the behavior
# implied by the tests in specs/board_spec.rb.  Run the spec with
#
#  rspec specs/board_spec.rb
#
# Aim for two things:
#   1. Every test passes (green)
#   2. Your code respects the intention behind the tests (don't be too literal)
#
# NOTE: You do NOT need to modify the initialize method.

class Board
  # These are now, e.g., Board::DimensionError
  class DimensionError < StandardError;end
  class CellError < StandardError;end

  attr_reader :row_count, :column_count

  # Allow rectangular boards.
  def initialize(row_count, column_count)
    unless row_count > 0
      raise DimensionError, "row_count must be > 0 (got #{row_count})"
    end

    unless column_count > 0
      raise DimensionError, "column_count must be > 0 (got #{column_count})"
    end

    @row_count    = row_count
    @column_count = column_count

    @board = Array.new(@row_count) { Array.new(@column_count) }
  end

  def get(row, column)
    raise_unless_dimensions_valid!(row, column)

    @board[row][column]
  end

  def place(row, column, piece)
    raise_unless_dimensions_valid!(row, column)
    raise_unless_cell_empty!(row, column)

    @board[row][column] = piece
  end

  def remove(row, column)
    raise_unless_dimensions_valid!(row, column)
    raise_unless_cell_occupied!(row, column)

    @board[row][column] = nil
  end

  private
  def raise_unless_dimensions_valid!(row, column)
   if row >= @row_count
      raise DimensionError, "row dimension is too large (got #{row})"
   end
   if column >= @column_count
     raise DimensionError, "column dimension is too large (got #{column})"
   end

  def raise_unless_cell_empty!(row, column)
    if @board[row][column] != nil
      raise CellError, "cell (#{row},#{column}) is already occupied"
    end
  end

  def raise_unless_cell_occupied!(row, column)
    if @board[row][column] == nil
      raise CellError, "cell (#{row},#{column}) is already empty"
    end
  end
  end
end
