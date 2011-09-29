class Specification < ActiveRecord::Base
  #  liquid_methods :id, :content, :specification_items
  liquid_methods :id, :key, :value

  belongs_to :product

  #  has_many :specification_items, :dependent => :destroy

  #  accepts_nested_attributes_for :specification_items,
  #    :reject_if => lambda { |x| x[:content].blank? },
  #    :allow_destroy => true
end
