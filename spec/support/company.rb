class Company < ActiveRecord::Base
  include VersionedRecord
  has_many :users, as: :entity
end
