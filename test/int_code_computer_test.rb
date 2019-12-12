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
    io = FakeIO.new([42])
    memory = [3, 3, 4, 666, 99]
    IntCodeComputer.new(memory, io).process
    assert_equal [42], io.std_out
    assert_equal [3,3,4,42,99], memory
  end

  def test_storing_value
    memory = [1, 0, 0, 0]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal 2, memory[0]
  end
end