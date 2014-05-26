class Installation < ActiveRecord::Base
  belongs_to :versioned_product
  belongs_to :office
end
