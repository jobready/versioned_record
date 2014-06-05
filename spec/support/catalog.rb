class Catalog < ActiveRecord::Base
  include VersionedRecord

  has_many :version_products, {
    foreign_key: [:catalog_id, :catalog_version]
  }
end
