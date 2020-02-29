require 'minitest/autorun'
require 'int_code_computer'
require 'array_io'

class IntCodeComputerTest < Minitest::Test
  def test_input_output
    io = ArrayIO.new([4])
    memory = [3, 3, 4, 666, 99]
    IntCodeComputer.new(memory, io).process
    assert_equal [99], io.std_out
    assert_equal [3, 3, 4, 4, 99], memory
  end

  def test_storing_value
    memory = [1001, 1, 1, 0, 99]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal 2, memory[0]
  end

  def test_immediate_args
    memory = [1002, 4, 3, 4, 33, 99]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal [1002, 4, 3, 4, 99, 99], memory
  end

  def test_negative_immediate
    memory = [1001, 3, -944, 3, 99]
    computer = IntCodeComputer.new(memory)
    computer.process
    assert_equal [1001, 3, -944, -941, 99], memory
  end

  def test_jump_if_true_jumps_if_parameter_is_non_zero
    memory = [1105, 42, 5, 4, 3, 0].to_memory
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal 0, memory.next_value
  end

  def test_jump_if_true_does_not_jump_if_parameter_is_zero
    memory = [1105, 0, 5, 4, 3, 0].to_memory
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal 4, memory.next_value
  end

  def test_jump_if_false
    memory = [1106, 0, 5, 4, 3, 0].to_memory
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal 0, memory.next_value
  end

  def test_less_than
    memory = [1107, 4, 5, 5, 3, 42, 99]
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal [1107, 4, 5, 5, 3, 1, 99], memory

    memory = [1107, 5, 5, 5, 3, 42, 99]
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal [1107, 5, 5, 5, 3, 0, 99], memory
  end

  def test_equality
    memory = [1108, 5, 4, 5, 3, 42, 99]
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal [1108, 5, 4, 5, 3, 0, 99], memory

    memory = [1108, 5, 5, 5, 3, 42, 99]
    program = Program.new(memory, ArrayIO.new).to_enum
    program.next.process
    assert_equal [1108, 5, 5, 5, 3, 1, 99], memory
  end

  def test_larger_example
    input = [3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31,
             1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104,
             999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99]

    io = ArrayIO.new([7, 8, 9])
    IntCodeComputer.new(input, io).process
    IntCodeComputer.new(input, io).process
    IntCodeComputer.new(input, io).process
    assert_equal [999, 1000, 1001], io.std_out
  end

  def test_get_next_output
    memory = [4,5,4,6,99,42,43, 99]
    io = ArrayIO.new
    program = IntCodeComputer.new(memory, io)
    program.get_next_output
    assert_equal 42, io.last_output
    program.get_next_output
    assert_equal 43, io.last_output
  end

  def test_complex_output_with_relative_offset
    memory = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    expected_output = memory.dup
    io = ArrayIO.new
    computer = IntCodeComputer.new(memory, io)
    computer.process
    assert_equal expected_output, io.std_out
  end

  def test_day_nine_part_one
    skip
    input = File.read('day_nine_input.txt').split(",").map(&:to_i)
    io = ArrayIO.new([1])
    computer = IntCodeComputer.new(input, io)
    computer.process
    p io.std_out
  end
end

class OpCodeTest < Minitest::Test
  def test_retrieving_in_positional_mode
    memory = [1, 2, 3, 0].to_memory
    subject = OpCode.new(Program.new(memory, ArrayIO.new))
    assert_equal 3, subject.first_parameter
    assert_equal 0, subject.second_parameter
  end

  def test_retrieving_in_immediate_mode
    memory = [1101, 3, 42, 0].to_memory
    subject = OpCode.new(Program.new(memory, ArrayIO.new))
    assert_equal 3, subject.first_parameter
    assert_equal 42, subject.second_parameter
    assert_equal 0, subject.write_parameter
  end
end
