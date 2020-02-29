require 'minitest/autorun'
require 'int_code_computer'

class InstructionTest < Minitest::Test
  def test_relative_base_adjustment
    memory = [109, 5, 109, 2, 99].to_memory
    subject = IntCodeComputer.new(memory)
    subject.process
    assert_equal 7, memory.offset
  end
end
