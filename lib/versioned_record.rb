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
    model_class.after_save :ensure_version_deprecation!, on: :create
  end

  def ensure_version_deprecation!
    if deprecate_old_versions_after_create?
      deprecate_old_versions(self)
    end
  end

  def deprecate_old_versions_after_create?
    @deprecate_old_versions_after_create
  end

  def deprecate_old_versions_after_create!
    @deprecate_old_versions_after_create = true
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
      created = self.class.create!(new_version_attributes(new_attrs)).tap do |created|
        deprecate_old_versions(created) if created.persisted?
      end
    end
  end

  def create_version(new_attrs = {})
    self.class.transaction do
      self.class.create(new_version_attributes(new_attrs)).tap do |created|
        deprecate_old_versions(created) if created.persisted?
      end
    end
  end

  def build_version(new_attrs = {})
    new_version = self.class.new(new_version_attributes(new_attrs)).tap do |built|
      built.deprecate_old_versions_after_create!
    end
  end

  # TODO: Possibly put this into a class
  def new_version_attributes(new_attrs = {})
    _new_attrs = new_attrs.stringify_keys
    self.attributes.merge(_new_attrs.merge({
      is_current_version: true,
      id:                 self.id,
      version:            self.version + 1
    }))
  end

  def deprecate_old_versions(current_version)
    versions.exclude(current_version).update_all(is_current_version: false)
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
