require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'

require 'composite_primary_keys'
require 'versioned_record/version'
require 'versioned_record/class_methods'
require 'versioned_record/connection_adapters/postgresql'

require 'byebug'

module VersionedRecord
  def self.included(model_class)
    model_class.extend ClassMethods
    model_class.primary_keys = :id, :version
  end

  # Create a new version of the existing record
  # A new version can only be created once for a given record and subsequent
  # versions must be created by calling create_version! on the latest version
  #
  # Attributes that are not specified here will be copied to the new version from
  # the previous version
  #
  # @example
  #
  #     person_v1 = Person.create(name: 'Dan')
  #     person_v2 = person_v1.create_version!(name: 'Daniel')
  #
  def create_version!(new_attrs = {})
    self.class.transaction do
      #new_attrs.stringify_keys!
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

  def create_version(new_attrs = {})
    self.class.transaction do
      new_attrs.stringify_keys!
      self.class.create(
        self.attributes.merge(new_attrs.merge({
          is_current_version: true,
          id:                 self.id,
          version:            self.version + 1
        }))
      ).tap do |created|
        versions.update_all(is_current_version: false) if created.persisted?
      end
    end
  end

  # Retrieve all versions of this record
  # Can be chained with other scopes
  #
  # @example Versions ordered by version number
  #
  #     person.versions.order(:version)
  #
  def versions
    self.class.where(id: self.id)
  end
end
