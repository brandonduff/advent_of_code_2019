class Instruction
  attr_reader :program, :parameters

  INSTRUCTIONS = []

  def self.for(op_code)
    INSTRUCTIONS.find(->{ raise "no instruction for code #{code}"}) { |instruction| instruction.code == op_code % 100 }
  end

  def self.code(code=nil)
    if code
      @code = code
      INSTRUCTIONS << self
    end
    @code
  end

  def self.parameter_count(count=nil)
    @parameter_count = count if count
    @parameter_count
  end

  def initialize(program, parameter_list)
    @program = program
    @parameters = parameter_list
  end

  def store(value)
    program[parameters.last] = value
  end
end


class Exit < Instruction
  code 99
  parameter_count 0

  def process
    program.halted = true
  end
end

class Multiplication < Instruction
  code 2
  parameter_count 3

  def process
    store(parameters[0] * parameters[1])
  end
end

class Addition < Instruction
  code 1
  parameter_count 3

  def process
    store(parameters[0] + parameters[1])
  end
end

class JumpIf < Instruction
  def process
    program.instruction_pointer = parameters[1] if should_jump?
  end
end

class JumpIfTrue < JumpIf
  code 5
  parameter_count 2

  def should_jump?
    !parameters[0].zero?
  end
end

class JumpIfFalse < JumpIf
  code 6
  parameter_count 2

  def should_jump?
    parameters[0].zero?
  end
end

class Output < Instruction
  code 4
  parameter_count 1

  def process
    program.io.put(parameters[0])
  end
end

class Input < Instruction
  code 3
  parameter_count 1

  def process
    store(program.io.get)
  end
end

class LessThan < Instruction
  code 7
  parameter_count 3

  def process
    if parameters[0] < parameters[1]
      store(1)
    else
      store(0)
    end
  end
end

class Equality < Instruction
  code 8
  parameter_count 3

  def process
    if parameters[0] == parameters[1]
      store(1)
    else
      store(0)
    end
  end
end

class AdjustRelativeBase < Instruction
  code 9
  parameter_count 1

  def process
    program.memory.offset += parameters[0]
  end
end
