require 'minitest/autorun'
require 'int_code_computer/memory'

class MemoryTest < Minitest::Test
  def test_default_allocation
    subject = Memory.new([])
    assert_equal 0, subject.next_value

    subject.offset = 5
    assert_equal 0, subject.next_relative_value
  end

  def test_next_relative_value
    subject = Memory.new([1,42,3,666])
    subject.offset = 2
    assert_equal 666, subject.next_relative_value
  end

  def test_default_offset
    assert_equal 0, Memory.new([]).offset
  end
end
