class VersionedProduct < ActiveRecord::Base
  include VersionedRecord
  validates :name, presence: true
  validates :name, length: { minimum: 2 }

  belongs_to :company

  # Simple Belongs To
  has_many :comments

  # Composite Belongs To
  has_many :sales, {
    foreign_key: [:versioned_product_id, :versioned_product_version],
    primary_key: [:id, :version ]
  }
end
