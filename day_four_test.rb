require_relative 'day_four'
require 'minitest/autorun'

class DayFourTest < Minitest::Test
  def test_double_digits
    refute Tester.valid?("124567")
    assert Tester.valid?("123566")
  end

  def test_digit_order
    refute Tester.valid?("123665")
    assert Tester.valid?("123367")
  end

  def test_length
    refute Tester.valid?("12355")
  end

  def test_counter
    assert 2, Counter.count("123455", "123466")
  end

  def test_puzzle_input
    p Counter.count("193651", "649729")
  end

  def test_complex_valid
    assert Tester.valid_complex?("111122")
    refute Tester.valid_complex?("123444")
  end
end
