class Container < ActiveRecord::Base
  include VersionedRecord

  belongs_to :versioned_product, {
    foreign_key: [:versioned_product_id, :versioned_product_version],
  }
end
