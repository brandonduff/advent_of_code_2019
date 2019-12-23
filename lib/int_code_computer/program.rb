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
