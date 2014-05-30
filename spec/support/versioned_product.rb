class VersionedProduct < ActiveRecord::Base
  include VersionedRecord
  validates :name, presence: true
  validates :name, length: { minimum: 2 }

  belongs_to :company

  # Simple Belongs To
  has_many :comments

  # Composite has many
  has_many :sales, {
    foreign_key: [:versioned_product_id, :versioned_product_version]
  }

  # Simple HABTM
  has_and_belongs_to_many :tags

  # Composite HABTM
  has_and_belongs_to_many :packages, {
    foreign_key: [:versioned_product_id, :versioned_product_version],
    association_foreign_key: :package_id
  }

  # Composite Mutual HABTM
  # TODO location?

  # Has one and has one through
  has_one :installation
  has_one :office, through: :installation

  # Composite has_one
  has_one :container, {
    foreign_key: [:versioned_product_id, :versioned_product_version]
  }
end
