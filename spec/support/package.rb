class Package < ActiveRecord::Base
  has_and_belongs_to_many :versioned_products, {
    association_foreign_key: [:versioned_product_id, :versioned_product_version],
    foreign_key: :package_id
  }
end
