class Program
  attr_reader :memory, :io
  include Enumerable
  extend Forwardable

  attr_writer :halted

  def_delegators :@memory, :[], :[]=
  def_delegators :@current_op_code, :first_parameter, :second_parameter, :write_parameter

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
    @current_op_code = OpCode.new(memory)
    @current_op_code.instruction_type.new(self)
  end
end
