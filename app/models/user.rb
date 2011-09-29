require 'digest/sha1'
class User < ActiveRecord::Base
  acts_as_authentic
  has_many :shops, :dependent => :destroy
  has_many :user_histories, :dependent => :destroy

  after_create :create_initial_shop

  #  user functionality
  def create_initial_shop
    shop = self.shops.create :name => 'My Shop'
  end

  def name_or_user
    (self.first_name.nil? or self.first_name.empty?)? "user" : "#{self.first_name}"
  end

  def name_or_email
    (self.first_name.nil? or self.first_name.empty?)? "#{self.email}" : "#{self.first_name}"
  end

  def name_or_blank
    (self.first_name.nil? or self.first_name.empty?)? "" : "#{self.first_name}"
  end

  #user roles functionality
  ROLES = %w[admin end]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  #reset password functionality

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end
end
