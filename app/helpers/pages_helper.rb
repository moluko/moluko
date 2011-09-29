module PagesHelper

  def check_product(text)
    if current_shop.products.size == 0
      task_uncomplete text
    else
      task_completed text
    end
  end

  def check_facebook(text)
    if current_shop.fb_ids.nil?
      task_uncomplete text
    else
      task_completed text
    end
  end

  def check_payment(text)
    if current_shop.paypal_email.nil? or
      current_shop.paypal_email.empty? or
      current_shop.paypal_currency.nil? or
      current_shop.paypal_currency.empty?
      task_uncomplete text
    else
      task_completed text
    end
  end

  def check_shipping_plan(text)
    if current_shop.shipping_plans.size == 0
      task_uncomplete text
    else
      task_completed text
    end
  end

  def check_subscription(text)
    if current_user.subscr_id.nil?
      task_uncomplete text
    else
      task_completed text
    end
  end

  def task_completed(text)
    tmp = "<td class='strike'>#{text}</td>"
    tmp += "<td class='completed'>completed!</td>"
  end

  def task_uncomplete(text)
    tmp = "<td>#{text}</td>"
  end
end
