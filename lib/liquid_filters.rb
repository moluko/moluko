module LiquidFilters
  include ActionView::Helpers::NumberHelper

  def currency_format(price)
    number_to_currency(price, :unit => "")
  end

  def visit_button(product)
    if product.enable_visit == "1"
      "<a href='#{product.url_to_product}'>Visit Store</a>"
    end
  end

  def buy_button(product)
    if product.enable_buy == "1"
      "<input type='submit' value='Buy It Now!' onclick='show_add_to_cart_dialog(#{product.id}); return false;'>"
    end
  end

end
