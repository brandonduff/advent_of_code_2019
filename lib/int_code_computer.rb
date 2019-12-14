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

class Exit
  def initialize(_program)

  end

  def process
    throw(:exit)
  end
end

class Multiplication
  attr_reader :second_operand, :store_location, :first_operand, :program

  def initialize(program)
    @program = program
    @first_operand = @program.first_parameter
    @second_operand = @program.second_parameter
    @store_location = @program.write_parameter
  end

  def process
    program[store_location] = first_operand * second_operand
  end
end

class Addition
  attr_reader :second_operand, :first_operand, :store_location, :program

  def initialize(program)
    @program = program
    @first_operand = program.first_parameter
    @second_operand = program.second_parameter
    @store_location = program.write_parameter
  end

  def process
    program[store_location] = first_operand + second_operand
  end
end

class Output
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def process
    program.io.put(program.first_parameter)
  end
end

class Input
  attr_reader :store_location, :program

  def initialize(program)
    @program = program
    @store_location = program.write_parameter
  end

  def process
    program[store_location] = program.io.get
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
    case op_code % 100
    when 1
      Addition
    when 2
      Multiplication
    when 4
      Output
    when 99
      Exit
    when 3
      Input
    else
      raise "op code: #{op_code} not recognized"
    end
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
