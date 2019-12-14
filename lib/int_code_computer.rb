require 'io/console'
require 'forwardable'

class Array
  def to_memory
    Memory.new(self)
  end
end

class IntCodeComputer
  attr_reader :input, :io

  def self.from_raw_input(raw_input)
    new(raw_input.split(',').map(&:to_i))
  end

  def self.process(input)
    new(input).process
  end

  def initialize(input, io = ComputerIO.new)
    @input = input
    @io = io
  end

  def process
    program = Program.new(input, io)
    catch(:exit) do
      program.process
    end
    program.memory
  end
end

class Instruction
  attr_reader :second_operand, :store_location, :first_operand, :program, :first_parameter, :second_parameter

  INSTRUCTIONS = []

  def self.for(op_code)
    INSTRUCTIONS.find(->{ raise "no instruction for code #{code}"}) { |instruction| instruction.code == op_code % 100 }
  end

  def self.code(code=nil)
    if code
      @code = code
      INSTRUCTIONS << self
    end
    @code
  end

  def self.parameter_count(count=nil)
    @parameter_count = count if count
    @parameter_count
  end

  def initialize(program)
    @program = program
    @first_parameter = @program.first_parameter if self.class.parameter_count > 0
    @second_parameter = @program.second_parameter if self.class.parameter_count > 1
    @store_location = @program.write_parameter if self.class.parameter_count > 2
  end

  def store(value)
    program[store_location] = value
  end
end

class Exit < Instruction
  code 99
  parameter_count 0

  def process
    throw(:exit)
  end
end

class Multiplication < Instruction
  code 2
  parameter_count 3

  def process
    store(first_parameter * second_parameter)
  end
end

class Addition < Instruction
  code 1
  parameter_count 3

  def process
    store(first_parameter + second_parameter)
  end
end

class JumpIf < Instruction
  def process
    program.instruction_pointer = second_parameter if should_jump?
  end
end

class JumpIfTrue < JumpIf
  code 5
  parameter_count 2

  def should_jump?
    !first_parameter.zero?
  end
end

class JumpIfFalse < JumpIf
  code 6
  parameter_count 2

  def should_jump?
    first_parameter.zero?
  end
end

class Output < Instruction
  code 4

  def initialize(program)
    @program = program
  end

  def process
    program.io.put(program.first_parameter)
  end
end

class Input < Instruction
  code 3
  parameter_count 1

  def initialize(program)
    @program = program
    @store_location = program.write_parameter
  end

  def process
    store(program.io.get)
  end
end

class LessThan < Instruction
  code 7
  parameter_count 3

  def process
    if first_parameter < second_parameter
      store(1)
    else
      store(0)
    end
  end
end

class Equality < Instruction
  code 8
  parameter_count 3

  def process
    if first_parameter == second_parameter
      store(1)
    else
      store(0)
    end
  end
end

class Memory
  extend Forwardable

  def initialize(storage)
    @storage = storage
    @instruction_pointer = storage.to_enum
  end

  def next_value
    @instruction_pointer.next
  end

  def next_value_at
    @storage[next_value]
  end

  def ==(other)
    @storage == other
  end

  def to_ary
    @storage
  end

  def to_memory
    self
  end

  def rewind
    @instruction_pointer.rewind
  end

  alias_method :to_a, :to_ary
  def_delegators :@storage, :[], :[]=
end

class Program
  attr_reader :memory, :io
  include Enumerable
  extend Forwardable

  def_delegators :@memory, :[], :[]=
  def_delegators :@current_op_code, :first_parameter, :second_parameter, :write_parameter

  def initialize(raw_memory, io)
    @memory = raw_memory.to_memory
    @io = io
  end

  def process
    each(&:process)
  end

  def instruction_pointer=(index)
    memory.rewind
    index.times { memory.next_value }
  end

  def each
    loop do
      @current_op_code = OpCode.new(memory)
      yield @current_op_code.instruction_type.new(self)
    end
  end
end

class OpCode
  attr_reader :memory, :op_code

  def initialize(memory)
    @memory = memory
    @op_code = @memory.next_value
  end

  def write_parameter
    memory.next_value
  end

  def first_parameter
    if (op_code / 100) % 10 == 1
      memory.next_value
    else
      memory.next_value_at
    end
  end

  def second_parameter
    if (op_code / 1000) % 10 == 1
      memory.next_value
    else
      memory.next_value_at
    end
  end

  def instruction_type
    Instruction.for(op_code)
  end
end

class ComputerIO
  def get
    STDIN.getch.to_i
  end

  def put(value)
    puts value
  end
end
