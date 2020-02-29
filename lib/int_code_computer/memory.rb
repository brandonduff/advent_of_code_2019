class Memory
  extend Forwardable

  attr_writer :offset

  def initialize(storage)
    @storage = storage
    @instruction_pointer = @storage.to_enum
  end

  def next_value
    @instruction_pointer.next
  rescue StopIteration
    0
  end

  def next_value_at
    @storage[next_value]
  end

  def next_relative_value
    @storage[next_value + @offset]
  end

  def ==(other)
    @storage == other
  end

  def to_ary
    @storage
  end

  def to_memory
    self
  end

  def rewind
    @instruction_pointer.rewind
  end

  alias_method :to_a, :to_ary
  def_delegators :@storage, :[], :[]=
end
