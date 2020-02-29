class Parameter < DelegateClass(Integer)
  def initialize(mode, memory, instruction=nil)
    @mode = ParameterMode.new(mode)
    @memory = memory
    super(value)
  end

  def value
    if mode.positional?
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

  attr_reader :memory, :mode
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
