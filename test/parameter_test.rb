require 'minitest/autorun'
require 'int_code_computer/parameter'

class ParameterTest < Minitest::Test
  def test_relative_offset_mode
    memory = [0,0,42].to_memory
    memory.offset = 2
    subject = Parameter.new(2, memory)
    assert_equal 42, subject.value
  end
end
