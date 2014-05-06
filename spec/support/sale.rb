class Sale < ActiveRecord::Base
  belongs_to :versioned_product, {
    foreign_key: [:versioned_product_id, :versioned_product_version],
    primary_key: [:id, :version ],
    autosave: false
  }
end
