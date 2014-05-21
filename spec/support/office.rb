class Office < ActiveRecord::Base
  has_one :installation
  has_one :versioned_product, through: :installation
end
