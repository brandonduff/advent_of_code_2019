class OpCode
  attr_reader :op_code, :memory

  def initialize(memory)
    @memory = memory
    @op_code = memory.next_value
  end

  def parameter_list
    @parameter_list ||= instruction_type.parameter_count.times.map do |i|
      Parameter.new((op_code / (10 ** (i + 2))) % 10, memory, instruction_type, (i + 1))
    end
  end

  def next_instruction(program)
    instruction_type.new(program, parameter_list)
  end

  private

  def instruction_type
    Instruction.for(op_code)
  end
end
