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
end
