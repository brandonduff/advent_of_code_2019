class Memory
  extend Forwardable

  def initialize(storage)
    @storage = storage
    @instruction_pointer = storage.to_enum
  end

  def next_value
    @instruction_pointer.next
  end

  def next_value_at
    @storage[next_value]
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