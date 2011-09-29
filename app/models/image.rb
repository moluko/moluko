require 'open-uri'
class Image < ActiveRecord::Base
  has_attached_file :data,
    :storage => :s3,
    :bucket => APP_CONFIG[:aws_s3]['assets_bucket'],
    :s3_credentials => { :access_key_id => APP_CONFIG[:aws_s3]['access_key_id'], :secret_access_key => APP_CONFIG[:aws_s3]['secret_access_key'] },
    :s3_headers => {'Expires' => 1.year.from_now.httpdate},
    :s3_host_alias => APP_CONFIG[:aws_s3]['host_alias'],

    :default_url => "#{::Rails.root.to_s}/images/missing/missing_:class_:style.png",
    :path => "/attachments/:class/:id/:style_:basename.:extension",
    :styles => { :normal => "450x450>", :medium => "200x200>", :thumb => "70x70>" }

  belongs_to :product
  attr_accessor :image_url
  before_validation :download_remote_image, :if => :image_url_provided?

  liquid_methods :data, :url_to_image, :thumb, :normal, :medium, :size, :id

  def size(size_type)
    self.data.url(size_type)
  end

  def medium
    self.data.url(:medium)
  end

  def thumb
    self.data.url(:thumb)
  end

  def normal
    self.data.url(:normal)
  end

  private

  def image_url_provided?
    !self.image_url.blank?
  end

  def download_remote_image
    self.data = do_download_remote_image
    self.url_to_image = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(self.image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
    rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end
