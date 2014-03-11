class VersionedProduct < ActiveRecord::Base
  include VersionedRecord
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
end
