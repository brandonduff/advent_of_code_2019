require 'io/console'
require 'forwardable'

class IntCodeComputer
  attr_reader :input, :io

  def self.from_raw_input(raw_input)
    new(raw_input.split(',').map(&:to_i))
  end

  def self.process(input)
    new(input).process
  end

  def initialize(input, io=ComputerIO.new)
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
  def initialize(program)
    @program = program
    @first_operand = @program[program.next_value]
    @second_operand = @program[program.next_value]
    @store_location = program.next_value
  end

  def process
    @program[@store_location] = @first_operand * @second_operand
  end
end

class Addition
  attr_reader :second_operand, :first_operand, :store_location

  def self.call(first_operand, second_operand)
    first_operand + second_operand
  end

  def initialize(program)
    @program = program
    @first_operand = @program[program.next_value]
    @second_operand = @program[program.next_value]
    @store_location = program.next_value
  end

  def process
    @program[@store_location] = first_operand + second_operand
  end
end

class Output
  attr_reader :value, :program

  def initialize(program)
    @program = program
    @value = program.next_value
  end

  def process
    program.io.put(value)
  end
end

class Input
  attr_reader :store_location, :program

  def initialize(program)
    @program = program
    @store_location = program.next_value
  end

  def process
    program[store_location] = program.io.get
  end
end

class Program
  attr_reader :memory, :io
  include Enumerable
  extend Forwardable

  def_delegators :@memory, :[], :[]=

  def initialize(memory, io)
    @memory = memory
    @current_position = memory.to_enum
    @io = io
  end

  def next_value
    @current_position.next
  end

  def process
    each(&:process)
  end

  def each
    loop do
      yield instruction_type_for_op_code(next_value).new(self)
    end
  end

  private

  def instruction_type_for_op_code(op_code)
    case op_code
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
    STDIN.getch
  end

  def put(value)
    puts value
  end
end
