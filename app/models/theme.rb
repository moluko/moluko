class Theme < ActiveRecord::Base

  acts_as_list
  has_many :theme_pages, :dependent => :destroy
  has_many :theme_images, :dependent => :destroy
  accepts_nested_attributes_for :theme_images, :allow_destroy => true

  liquid_methods :theme_images

end
