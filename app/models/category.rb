class Category < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20

  acts_as_list
  belongs_to :shop
  belongs_to :user
  has_many :products
  validates_presence_of :name

  liquid_methods :id, :name, :url

  def url
    "?category_id=#{self.id}"
  end

end
