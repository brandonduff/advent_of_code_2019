require 'minitest/autorun'
require 'day_eight'

class Day8Test < Minitest::Test
  def test_breaking_into_3_layers
    input = [1,2,3,4,5,6]
    width = 2
    height = 1
    image = Image.new(input, width, height)
    assert_equal 3, image.layers.count
  end

  def test_2d_layers
    input = [1,2,3,4,5,6,7,8]
    width = 2
    height = 2
    image = Image.new(input, width, height)
    assert_equal 2, image.layers.count
  end

  def test_layer_zero_count
    layer = Layer.new([1,2,0,0])
    assert_equal 2, layer.zero_count
  end

  def test_layer_value
    layer = Layer.new([1,2,0,0,1,2,3])
    assert_equal 4, layer.value
  end
end
