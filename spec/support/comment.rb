class Comment < ActiveRecord::Base
  belongs_to :versioned_product
end
