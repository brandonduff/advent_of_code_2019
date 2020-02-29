class OpCode
  attr_reader :op_code, :program

  def initialize(program)
    @program = program
    @op_code = memory.next_value
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

  def instruction
    instruction_type.new(program)
  end

  private

  def memory
    program.memory
  end
end
