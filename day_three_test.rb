require 'minitest/autorun'
require_relative 'day_three'

class DayThreeTest < Minitest::Test
  def test_logging_points
    board = WirePositions.new([Instruction.new('R', 1), Instruction.new('U', 1), Instruction.new('L', 1), Instruction.new('D', 1)])
    assert_equal Point.new(0,0), board.first
    assert_equal Point.new(1,0), board.entries[1]
    assert_equal Point.new(1,1), board.entries[2]
    assert_equal Point.new(0,1), board.entries[3]
    assert_equal Point.new(0,0), board.entries[4]
  end

  def test_moving_multiple_spaces
    board = WirePositions.new([Instruction.new('R', 2)])
    assert_equal Point.new(1, 0), board.entries[1]
    assert_equal Point.new(2, 0), board.entries[2]
  end

  def test_intersections_drops_until_divergence
    first_board = WirePositions.new([Instruction.new('U', 1), Instruction.new('R', 1)])
    second_board = WirePositions.new([Instruction.new('R', 1), Instruction.new('U', 1)])
    assert_equal Point.new(1, 1), first_board.intersections_with(second_board).first
  end

  def test_first_sample
    subject = DayThree.new(<<~INPUT)
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
INPUT
    subject.solution
  end

  def test_second_sample
    subject = DayThree.new(<<~INPUT)
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
INPUT
    subject.solution
  end

  def test_first_input
    subject = DayThree.new(File.read('day_three_part_one.txt'))
    subject.solution
  end

  def test_manhattan_distance
    assert_equal 3, Point.new(-1, 2).manhattan_distance
  end

  def test_total_steps
    board = WirePositions.new([Instruction.new('U', 1), Instruction.new('R', 1), Instruction.new('D', 1)])
    assert_equal 3, board.steps_taken(board.entries.last)
  end

  def test_complex_sample
    subject = DayThree.new(<<~INPUT)
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
    INPUT
    subject.complex_solution

    other_subject = DayThree.new(<<~INPUT)
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
    INPUT
    other_subject.complex_solution
  end

  def test_second_input
    subject = DayThree.new(File.read('day_three_part_one.txt'))
    p subject.complex_solution
  end
end
