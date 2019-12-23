require 'io/console'
require 'forwardable'
Dir[File.join(__dir__, 'int_code_computer', '*.rb')].each(&method(:require))

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

class ComputerIO
  def get
    STDIN.getch.to_i
  end

  def put(value)
    puts value
  end
end
