require 'minitest/autorun'
require 'int_code_computer'

class OpCodeTest < Minitest::Test
  def test_retrieving_in_positional_mode
    memory = [1, 2, 3, 0].to_memory
    subject = OpCode.new(memory)
    assert_equal 3, subject.parameter_list.first
    assert_equal 0, subject.parameter_list[1]
  end

  class ParameterListTest < Minitest::Test
    def test_no_param_instruction
      memory = [99].to_memory
      subject = OpCode.new(memory)
      assert_equal [], subject.parameter_list
    end

    def test_single_param_instruction
      memory = [103, 42].to_memory
      subject = OpCode.new(memory)
      result = subject.parameter_list
      assert_equal 1, result.length
      assert_equal 42, result.first
    end

    def test_multi_param_instruction
      memory = [101, 42, 666, 123].to_memory
      subject = OpCode.new(memory)
      result = subject.parameter_list
      assert_equal 3, result.length
      assert_equal 42, result.first
      assert_equal 0, result[1]
      assert_equal 123, result[2]
    end
  end
end
