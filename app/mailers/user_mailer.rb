class UserMailer < ActionMailer::Base
  default :from => 'Moluko <team@moluko.com>', :return_path => 'team@moluko.com'

  def password_reset_instructions(user)
    @reset_password_url = "http://#{APP_CONFIG[:domain_name]}/password_resets/#{user.perishable_token}/edit"
    mail :to => user.email, :subject => "Reset your password", :tag => "reset-password"
  end

  def order_completed_notification(order)
    @order = order
    mail :to => order.shop.user.email,
      :subject => "You have received payment from #{order.payer_email}", :tag => "new-user"
  end

end
