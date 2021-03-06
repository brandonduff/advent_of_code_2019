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

  def initialize(input, io = ArrayIO.new)
    @input = input
    @io = io
  end

  def process
    program.process
    program.memory
  end

  def get_next_output
    program.advance_to_next_output
  end

  def halted?
    program.halted?
  end

  def program
    @program ||= Program.new(input, io)
  end
end
