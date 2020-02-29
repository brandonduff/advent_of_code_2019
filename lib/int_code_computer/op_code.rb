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
    Parameter.new((op_code / 100) % 10, memory)
  end

  def second_parameter
    Parameter.new((op_code / 1000) % 10, memory)
  end

  def instruction_type
    Instruction.for(op_code)
  end

  class Parameter < DelegateClass(Integer)
    def initialize(mode, memory)
      @mode = mode
      @memory = memory
      super(value)
    end

    def value
      if mode.zero?
        memory.next_value_at
      else
        memory.next_value
      end
    end

    private

    attr_reader :memory, :mode
  end
end
