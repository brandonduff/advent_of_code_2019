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
