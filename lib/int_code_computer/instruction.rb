class Instruction
  attr_reader :second_operand, :store_location, :first_operand, :program, :first_parameter, :second_parameter

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

  def initialize(program)
    @program = program
    @first_parameter = @program.first_parameter if self.class.parameter_count > 0
    @second_parameter = @program.second_parameter if self.class.parameter_count > 1
    @store_location = @program.write_parameter if self.class.parameter_count > 2
  end

  def store(value)
    program[store_location] = value
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
    store(first_parameter * second_parameter)
  end
end

class Addition < Instruction
  code 1
  parameter_count 3

  def process
    store(first_parameter + second_parameter)
  end
end

class JumpIf < Instruction
  def process
    program.instruction_pointer = second_parameter if should_jump?
  end
end

class JumpIfTrue < JumpIf
  code 5
  parameter_count 2

  def should_jump?
    !first_parameter.zero?
  end
end

class JumpIfFalse < JumpIf
  code 6
  parameter_count 2

  def should_jump?
    first_parameter.zero?
  end
end

class Output < Instruction
  code 4

  def initialize(program)
    @program = program
  end

  def process
    program.io.put(program.first_parameter)
  end
end

class Input < Instruction
  code 3
  parameter_count 1

  def initialize(program)
    @program = program
    @store_location = program.write_parameter
  end

  def process
    store(program.io.get)
  end
end

class LessThan < Instruction
  code 7
  parameter_count 3

  def process
    if first_parameter < second_parameter
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
    if first_parameter == second_parameter
      store(1)
    else
      store(0)
    end
  end
end
