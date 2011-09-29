module SalesHelper
  def sales_total_weight(order)
    total = 0
    order.order_items.each { |order_item| total += order_item.product_quantity * order_item.product_weight }
    total
  end
  def sales_total_item(order)
    total = 0
    order.order_items.each { |order_item| total += order_item.product_quantity }
    total
  end
  def sales_total(order)
    total = 0.0
    order.order_items.each { |order_item| total += order_item.product_price * order_item.product_quantity }
    total += order.shipping_fee
    "#{Shop::PAYPAL_CURRENCY[order.mc_currency][0]} #{total}"
  end
  def sales_subtotal(order)
    total = 0.0
    order.order_items.each { |order_item| total += order_item.product_price * order_item.product_quantity }
    "#{Shop::PAYPAL_CURRENCY[order.mc_currency][0]} #{total}"
  end
  def sales_shipping(order)
    "#{Shop::PAYPAL_CURRENCY[order.mc_currency][0]} #{order.shipping_fee}"
  end
end
