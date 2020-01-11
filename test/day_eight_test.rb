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

  def test_collapsing_two_layers
    first_layer = Layer.new([0,0,1,2])
    second_layer = Layer.new([1,1,2,0])
    assert_equal [0,0,1,0], first_layer.collapse_into(second_layer)
  end

  def test_collapsing_layers
    input = [0,2,2,2,1,1,2,2,2,2,1,2,0,0,0,0]
    width = 2
    height = 2
    image = Image.new(input, width, height)
    collapsed_layer = image.collapsed_layer
    assert_equal [0,1,1,0], collapsed_layer
  end

  def test_part_two
    skip
    input = File.read('day_eight_input.txt').split('').map(&:to_i)
    image = Image.new(input, 25, 6)
    image.write_out
  end
end
