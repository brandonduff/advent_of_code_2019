class Program
  attr_reader :memory, :io
  include Enumerable
  extend Forwardable

  attr_writer :halted

  def_delegators :@memory, :[], :[]=

  def initialize(raw_memory, io)
    @memory = raw_memory.to_memory
    @io = io
    @halted = false
  end

  def process
    each(&:process)
  end

  def instruction_pointer=(index)
    memory.rewind
    index.times { memory.next_value }
  end

  def halted?
    @halted
  end

  def each
    loop do
      yield next_instruction
      raise StopIteration if halted?
    end
  end

  def advance_to_next_output
    find do |instruction|
      instruction.process
      instruction.is_a?(Output)
    end
  end

  def next_instruction
    OpCode.new(memory).next_instruction(self)
  end
end
