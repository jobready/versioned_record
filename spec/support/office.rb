class Office < ActiveRecord::Base
  has_many :installations
  has_many :versioned_products, through: :installations
end
