class Shop < ActiveRecord::Base
  acts_as_list :scope => :user
  belongs_to :user
  has_many :orders
  has_many :order_items, :through => :orders
  has_many :shop_logs
  has_many :products
  has_many :images, :through => :products
  has_many :specifications, :through => :products
  has_many :categories
  has_many :shop_pages
  has_many :shipping_plans
  has_many :shop_histories
  has_many :carts
  has_many :cart_items, :through => :carts

  liquid_methods :paypal_email, :paypal_currency, :id

  validates_presence_of :name
  validates_format_of :paypal_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => true, :allow_nil => true

  after_create :create_activation_key

  def create_activation_key
    self.activation_key = Digest::SHA1.hexdigest("#{self.name}#{Time.now.to_s.split(//).sort_by {rand}.join}")
    self.save( :validate => false )
  end

  def fb_ids_url
    if self.fb_ids.nil?
      "#"
    else
      "http://www.facebook.com/pages/#{self.fb_ids}/#{self.fb_ids}?#{APP_CONFIG[:fb_app_id]}"
    end
  end

  def status_name
    temp = case self.status
           when 1 then "Open"
           when 0 then "Close"
           end
    temp
  end

  def theme_name
    case self.theme_id
    when nil
      Theme.order('position').first.name
    when 0
      "Custom Design"
    else
      Theme.find_by_id(self.theme_id).name
    end
  end

  def paypal_currency_symbol
    PAYPAL_CURRENCY[self.paypal_currency][0]
  end

  PAYPAL_CURRENCY = {
    'AUD' => ['AU$', 'Australian Dollar'],
    'CAD' => ['C$', 'Canadian Dollar'],
    'CZK' => ['Kč', 'Czech Koruna'],
    'DKK' => ['kr', 'Danish Krone'],
    'EUR' => ['€', 'Euro'],
    'HKD' => ['HK$', 'Hong Kong Dollar'],
    'HUF' => ['Ft', 'Hungarian Forint'],
    'ILS' => ['₪', 'Israeli New Sheqel'],
    'JPY' => ['¥', 'Japanese Yen'],
    'MYR' => ['RM', 'Malaysian Ringgit'],
    'MXN' => ['Mex$', 'Mexican Peso'],
    'NOK' => ['kr', 'Norwegian Krone'],
    'NZD' => ['NZ$', 'New Zealand Dollar'],
    'PHP' => ['₱', 'Philippine Peso'],
    'PLN' => ['zł', 'Polish Zloty'],
    'GBP' => ['£', 'Pound Sterling'],
    'SGD' => ['S$', 'Singapore Dollar'],
    'SEK' => ['kr', 'Swedish Krona'],
    'CHF' => ['CHF', 'Swiss Franc'],
    'TWD' => ['NT$', 'Taiwan New Dollar'],
    'THB' => ['฿', 'Thai Baht'],
    'USD' => ['US$', 'U.S. Dollar']
  }

end
