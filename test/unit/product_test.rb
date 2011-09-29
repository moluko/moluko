require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    product = Product.new
    assert !product.valid?
  end

  test "valid with right attributes" do
    product = Product.new :title => "shirt", :price => "1"
    assert product.valid?
  end

end
