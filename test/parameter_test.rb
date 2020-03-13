require 'minitest/autorun'
require 'int_code_computer/parameter'

class ParameterTest < Minitest::Test
  def test_relative_offset_mode
    memory = [0,0,42].to_memory
    memory.offset = 2
    subject = Parameter.new(2, memory, Instruction, 1)
    assert_equal 42, subject.value
  end

  class WriteParametersTest < Minitest::Test
    def setup
      @memory = [42].to_memory
    end

    def test_third_parameter_mode_0
      subject = Parameter.new(0, @memory, Addition, 3)
      assert_equal 42, subject
    end

    def test_third_parameter_mode_1
      subject = Parameter.new(1, @memory, Addition, 3)
      assert_equal 42, subject
    end

    def test_input_is_write_parameter
      subject = Parameter.new(0, @memory, Input, 1)
      assert_equal 42, subject
    end

    def test_write_parameter_with_mode_2
      @memory.offset = 2
      subject = Parameter.new(2, @memory, Input, 1)
      assert_equal 44, subject
    end
  end
end
