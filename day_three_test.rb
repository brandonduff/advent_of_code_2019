require 'minitest/autorun'
require_relative 'day_three'

class DayThreeTest < Minitest::Test
  def test_starts_at_origin
    input =  <<~BOARD
    ..
    O.
    BOARD

    assert_equal BoardCell.new(1, 0, 'O'), DayThree.new(input).current_position
  end

  def test_board_can_return_neighbors
    input = <<~BOARD
    ..
    O.
    BOARD

    board = Board.new(input)
    cell = BoardCell.new(1, 0, 'O')
    neighbors = board.neighbors(cell).map(&:position)
    assert_includes neighbors, Point.new(0, 0)
    assert_includes neighbors, Point.new(1, 1)
    refute_includes neighbors, Point.new(0, 1)
    refute_includes neighbors, Point.new(1, 0)
    refute_includes neighbors, Point.new(2, 0)
  end

  def test_can_check_if_position_is_within_board
    input = <<~BOARD
    ..
    O.
    BOARD

    board = Board.new(input)
    assert board.include?(BoardCell.new(0, 0, '.'))
    refute board.include?(BoardCell.new(2, 0, 'O'))
    refute board.include?(BoardCell.new(-1, 0, '.'))
  end

  def test_advancing_along_wire
    input = <<~BOARD
    +-X
    |..
    O-X
    BOARD

    subject = DayThree.new(input)
    subject.find_answer

    assert_equal 2, subject.answer
  end

  def test_simple_input

  end
end
