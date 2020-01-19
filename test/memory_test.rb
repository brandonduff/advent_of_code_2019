require 'minitest/autorun'
require 'int_code_computer/memory'

class MemoryTest < Minitest::Test
  def test_default_allocation
    subject = Memory.new([])
    assert_equal 0, subject.next_value
  end
end
