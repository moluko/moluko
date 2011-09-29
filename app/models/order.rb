class Order < ActiveRecord::Base
  belongs_to :shop
  acts_as_list :scope => :shop

  has_many :order_items, :dependent => :destroy
  accepts_nested_attributes_for :order_items, :allow_destroy => true

  def to_param
    self.position
  end

end
