require 'minitest/autorun'
require 'day_two'

class DayTwoTest < Minitest::Test
  def test_add
    assert_equal [2, 0, 0, 0, 99], DayTwo.call([1, 0, 0, 0, 99])
  end

  def test_multiply
    assert_equal [2, 4, 0, 1, 99], DayTwo.call([2, 0, 0, 1, 99])
  end

  def test_exit_code
    expected_output = input = [99, 5, 2, 3, 0]
    assert_equal expected_output, DayTwo.call(input)
  end

  def test_mutating_input_array
    input = [1,1,1,4,99,5,6,0,99]
    expected_output = [30,1,1,4,2,5,6,0,99]
    assert_equal expected_output, DayTwo.call(input)
  end

  def test_can_put_after_exit_code
    input = [2,4,4,5,99,0]
    expected_output = [2,4,4,5,99,9801]
    assert_equal expected_output, DayTwo.call(input)
  end

  def test_part_one
    skip
    input = File.read('day_two_input.txt').split(',').map(&:to_i)
    puts DayTwo.call(input).join(",")
  end

  def test_part_two
    skip
    expected_result = 19690720
    input = File.read('day_two_input.txt').split(',').map(&:to_i)
    (0...99).each do |noun|
     (0...99).each do |verb|
       attempt = input.dup
       attempt[1] = noun
       attempt[2] = verb
       if DayTwo.call(attempt)[0] == expected_result
         puts 100 * noun + verb
         return
       end
     end
    end
    raise 'not found'
  end
end
