class Array
  def to_layer
    Layer.new(self)
  end
end

class Image
  attr_reader :input, :width, :height

  def initialize(input, width, height)
    @input = input
    @width = width
    @height = height
  end

  def layers
    input.each_slice(width * height).map(&:to_layer)
  end

  def collapsed_layer
    layers.reduce(&:collapse_into)
  end

  def write_out
    collapsed_layer.to_a.each_slice(width).map do |row|
      row.map do |c|
        print case c
        when 1
          '#'
        when 0
          ' '
        end
        print " "
      endr
      puts "\n"
    end
  end
end

class Layer
  def initialize(data)
    @data = data
  end

  def zero_count
    @data.count(&:zero?)
  end

  def value
    @data.count { |e| e == 1 } * @data.count { |e| e == 2 }
  end

  def collapse_into(other_layer)
    @data.zip(other_layer).map do |first, second|
      if first == 2
        second
      else
        first
      end
    end.to_layer
  end

  def to_a
    @data
  end

  alias_method :to_ary, :to_a

  def ==(other)
    other.to_a == @data
  end
end
