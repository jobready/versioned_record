require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'

require 'composite_primary_keys'
require 'versioned_record/version'
require 'versioned_record/class_methods'
require 'versioned_record/connection_adapters/postgresql'

module VersionedRecord
  def self.included(model_class)
    model_class.extend ClassMethods
    model_class.primary_keys = :id, :version
  end

  def create_version!(new_attrs = {})
    self.class.transaction do
      versions.update_all(is_current_version: false)
      self.class.create!(
        self.attributes.merge(new_attrs.merge({
          is_current_version: true,
          id:                 self.id,
          version:            self.version + 1
        }))
      )
    end
  end

  def versions
    self.class.where(id: self.id)
  end
end
