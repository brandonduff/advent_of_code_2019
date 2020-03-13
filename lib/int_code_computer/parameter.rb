class Parameter < DelegateClass(Integer)
  def initialize(mode, memory, instruction_type, position)
    @mode = ParameterMode.new(mode)
    @memory = memory
    @instruction_type = instruction_type
    @position = position
    super(value)
  end

  def value
    @value ||= if position == 3 || @instruction_type == Input
      if mode.relative?
        memory.next_value + memory.offset
      else
        memory.next_value
      end
    elsif mode.positional?
      memory.next_value_at
    elsif mode.immediate?
      memory.next_value
    elsif mode.relative?
      memory.next_relative_value
    else
      raise 'unknown mode'
    end
  end

  private

  attr_reader :memory, :mode, :position, :instruction_type
end

class ParameterMode
  def initialize(code)
    @code = code
  end

  def positional?
    code == 0
  end

  def immediate?
    code == 1
  end

  def relative?
    code == 2
  end

  private

  attr_reader :code
end
