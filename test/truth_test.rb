require 'test_helper'

class TruthTest < Minitest::Test
  def test_array_can_be_created_with_no_arguments
    assert_instance_of Array, Array.new
  end

  def test_array_of_specific_length_can_be_created
    assert_equal 10, Array.new(10).size
  end
end
