class Product < ActiveRecord::Base

  #has_many :sources, :as => :sourceable
  #has_many :manual_filters, :through => :sources,
           #:source => :filtrable, :source_type => 'ManualFilter'
  #has_many :dinamic_filters, :through => :sources,
           #:source => :filtrable, :source_type => 'DinamicFilter'


  acts_as_indexed :fields => [:name, :description]
  alias_attribute :title, :name

  has_friendly_id :name, :use_slug => true
  
  #has_many :comments, :as => :comentable

  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :price, :presence => true

  #has_many :videos, :through => :video_product
  #has_many :video_products
  belongs_to :picture, :class_name => 'Image'
  belongs_to :brand
  belongs_to :category
  belongs_to :sub_category, :class_name => 'Category'
  
  has_many :love, :as => :loveable
  has_many :cart_items
  
  before_destroy :ensure_not_referenced_by_any_cart_item

  def loved_by?(member)
    love.map(&:member_id).include? member.id if member
  end

  def self.by_brand(brand)
    joins(:brand).where(:brands => {:name => brand})
  end

  def self.by_category(category)
    joins(:category).where(:categories => {:name => category})
  end
  
  def ensure_not_referenced_by_any_cart_item
    if car_items.count.zero?
      return true
    else
      errors[:base] << "Cart Items present"
      return false
    end
  end
end
