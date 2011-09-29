class CheckoutNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    par = { :cmd => '_notify-validate' }
    par.merge!(params)
    conn = Net::HTTP.new(APP_CONFIG[:paypal_url].gsub("https://",""))
    resp = conn.post('/cgi-bin/webscr?', par.to_query)
    #logger.info '0001 Respond return'
    if resp.instance_of?(Net::HTTPOK) and resp.body == "VERIFIED"
      #logger.info '0002 Respond verified'
      paypal_parameter = PaypalParameter.create :parameters => params.map{|key, value| ["#{key} => #{value}"]}.join(" | ")
      case params[:txn_type]
      when 'cart'
        if params[:payment_status] == "Completed"

          cart = Cart.find_by_id params[:custom]
          unless cart.nil?
            par = {}

            par[:order_items_attributes] = []
            par[:paypal_parameter_id] = paypal_parameter.id
            par[:payer_email] = params[:payer_email]
            par[:payment_status] = params[:payment_status]
            par[:txn_id] = params[:txn_id]
            par[:mc_currency] = params[:mc_currency]
            par[:address_name] = params[:address_name]
            par[:address_street] = params[:address_street]
            par[:address_city] = params[:address_city]
            par[:address_state] = params[:address_state]
            par[:address_zip] = params[:address_zip]
            par[:address_country] = params[:address_country]
            par[:address_country_code] = params[:address_country_code]
            par[:first_name] = params[:first_name]
            par[:last_name] = params[:last_name]
            par[:memo] = params[:memo]

            par[:fb_ids] = cart.fb_ids
            par[:shipping_fee] = cart.shipping_fee
            par[:country] = cart.country
            par[:region] = cart.region
            par[:zipcode] = cart.zipcode
            par[:delivery_type] = cart.delivery_type

            cart.cart_items.each do |cart_item|
              par[:order_items_attributes] << {
                :product_title => cart_item.product.title_with_specifications,
                :product_quantity => cart_item.quantity,
                :product_weight => cart_item.product.weight,
                :product_sku => cart_item.product.sku,
                :product_price => cart_item.product.final_price
              }
            end

            shop = cart.shop
            order = shop.orders.build par

            if order.save
              cart.destroy
              UserMailer.order_completed_notification(order).deliver
            end
          end
        end
      end

    end
    render :nothing => true
  end

end
