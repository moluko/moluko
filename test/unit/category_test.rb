require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "invalid with empty attributes" do
    category = Category.new
    assert !category.valid?
  end

  test "valid with right attributes" do
    category = Category.new :name => "Shift"
    assert category.valid?
  end
end
