class Product < ActiveRecord::Base

  liquid_methods :id,
    :title,
    :title_with_specifications,
    :price,
    :discount_price,
    :discount_status,
    :discount_for_fan_status,
    :description,
    :category,
    :images,
    :specifications,
    :enable_visit,
    :enable_buy,
    :free_shipping,
    :url_to_product,
    :shop,
    :group_specification,
    :specifications_string,
    :truncate_title

  cattr_reader :per_page
  @@per_page = 20

  acts_as_list :scope => :shop
  belongs_to :user
  belongs_to :category
  belongs_to :shop
  has_many :cart_items, :dependent => :destroy

  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  has_many :specifications, :dependent => :destroy
  accepts_nested_attributes_for :specifications, :allow_destroy => true

  validates_presence_of :title

  validates_presence_of :price
  validates_numericality_of :price

  validates_presence_of :weight
  validates_numericality_of :weight

  validates_numericality_of :discount_price, :if => Proc.new { |product| product.discount_status == '1' }

  validates_length_of :title, :maximum => 255, :message => "*too long"

  def category_name
    category.nil? ? "Uncategorized" : category.name
  end

  def discount_percentage
    if self.price.nil? or self.discount_price.nil? or self.discount_price > self.price
      0
    else
      (1 - self.discount_price / self.price) * 100
    end
  end

  def title_with_specifications
    spec = self.specifications.collect{|x| "#{x.key}: #{x.value}"}.join(", ")
    spec = ' (' + spec + ')' unless spec.blank?
    self.title + spec
  end

  def specifications_string
    self.specifications.collect{|x| "#{x.key}: #{x.value}"}.join(", ")
  end

  def full_title
    x = title_with_specifications
    x += ' - (Group by: ' + self.group_specification + ')' unless self.group_specification.blank?
    x
  end

  def truncate_title
    words = self.title.split
    length = 15
    words[0..(length - 1)].join(' ') + (words.length > length ? ' ...' : '')
  end

  def final_price
    self.discount_status == '1' ? self.discount_price : self.price
  end

end
