class ThemeImage < ActiveRecord::Base
  belongs_to :theme
  has_attached_file :data,
    :storage => :s3,
    :bucket => APP_CONFIG[:aws_s3]['assets_bucket'],
    :s3_credentials => { :access_key_id => APP_CONFIG[:aws_s3]['access_key_id'], :secret_access_key => APP_CONFIG[:aws_s3]['secret_access_key'] },
    :s3_headers => {'Expires' => 1.year.from_now.httpdate},
    :s3_host_alias => APP_CONFIG[:aws_s3]['host_alias'],

    :default_url => "#{::Rails.root.to_s}/images/missing/missing_:class_:style.png",
    :path => "/attachments/:class/:id/:style_:basename.:extension",
    :styles => { :thumbnail => "100x100>" }

  liquid_methods :data, :original

  def original
    self.data.url(:original)
  end

end
