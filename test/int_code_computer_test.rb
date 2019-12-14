require 'minitest/autorun'
require 'int_code_computer'

class IntCodeComputerTest < Minitest::Test
  class FakeIO
    attr_reader :std_in

    def initialize(input=[])
      @std_in = input
    end

    def get
      std_in.shift
    end

    def put(value)
      std_out << value
    end

    def std_in=(value)
      @std_in = value
    end

    def std_out
      @std_out ||= []
    end
  end

  def test_input_output
    io = FakeIO.new([4])
    memory = [3, 3, 4, 666, 99]
    IntCodeComputer.new(memory, io).process
    assert_equal [99], io.std_out
    assert_equal [3,3,4,4,99], memory
  end

  def test_storing_value
    memory = [1001, 1, 1, 0]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal 2, memory[0]
  end

  def test_immediate_args
    memory = [1002,4,3,4,33]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal [1002,4,3,4,99], memory
  end

  def test_negative_immediate
    memory = [1001,3,-944,3,99]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal [1001,3,-944,-941,99], memory
  end
end

class OpCodeTest < Minitest::Test
  def test_retrieving_in_positional_mode
    memory = [1,2,3,0].to_memory
    subject = OpCode.new(memory)
    assert_equal 3, subject.first_parameter
    assert_equal 0, subject.second_parameter
  end

  def test_retrieving_in_immediate_mode
    memory = [1101,3,42,0].to_memory
    subject = OpCode.new(memory)
    assert_equal 3, subject.first_parameter
    assert_equal 42, subject.second_parameter
    assert_equal 0, subject.write_parameter
  end
end