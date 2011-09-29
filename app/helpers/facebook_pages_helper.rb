module FacebookPagesHelper
  def liquidize(content, arguments)
    Liquid::Template.parse(content).render(arguments, :filters => [LiquidFilters] )
  end

  def cart_subtotal(cart)
    cart.cart_items.inject(0) { |s, cart_item| s += cart_item.product.final_price * cart_item.quantity }
  end

  def cart_quantity(cart)
    cart.cart_items.inject(0) { |s, cart_item| s += cart_item.quantity }
  end

  def cart_total(cart)
    cart_subtotal(cart) + cart.shipping_fee
  end

end
