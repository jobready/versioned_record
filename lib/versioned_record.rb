
require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'

require 'composite_primary_keys'
require 'versioned_record/attribute_builder'
require 'versioned_record/class_methods'
require 'versioned_record/connection_adapters/postgresql'
require 'versioned_record/attribute_methods/write'
require 'versioned_record/version'
require 'versioned_record/composite_predicates'
require 'versioned_record/active_record_versioning'

ActiveRecord::Associations::AssociationScope.include(VersionedRecord::CompositePredicates)

module VersionedRecord
  def self.included(model_class)
    model_class.primary_keys = :id, :version
    model_class.after_save :ensure_version_deprecation!, on: :create
    model_class.extend ClassMethods
    model_class.include InstanceMethods
  end

  module InstanceMethods
    # @return just the ID integer value (not the composite id, version key)
    def _id
      id[0]
    end

    # Create a new version of the existing record
    # A new version can only be created once for a given record and subsequent
    # versions must be created by calling create_version! on the latest version
    #
    # Attributes that are not specified here will be copied to the new version from
    # the previous version
    #
    # This method will still fire ActiveRecord callbacks for save/create etc as per
    # normal record creation
    #
    # @example
    #
    #     person_v1 = Person.create(name: 'Dan')
    #     person_v2 = person_v1.create_version!(name: 'Daniel')
    #
    def create_version!(new_attrs = {})
      create_operation do
        self.class.create!(new_version_attrs(new_attrs))
      end
    end

    # Same as #create_version! but will not raise if the record is invalid
    # @see VersionedRecord#create_version!
    #
    def create_version(new_attrs = {})
      create_operation do
        self.class.create(new_version_attrs(new_attrs))
      end
    end

    # Build (but do not save) a new version of the record
    # This allows you to use the object in forms etc
    # After the record is saved, all previous versions will be deprecated
    # and this record will be marked as current
    #
    # @example
    #
    #     new_version = first_version.build_version
    #     new_version.save
    #
    def build_version(new_attrs = {})
      new_version = self.class.new(new_version_attrs(new_attrs)).tap do |built|
        built.deprecate_old_versions_after_create!
        preserve_has_one_associations_to(built) 
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
      self.class.where(id: self._id)
    end

    # Retrieve the current version of an object
    # (May be itself)
    #
    def current_version
      versions.current_versions.first
    end

    # Ensure that old versions are deprecated when we save
    # (only applies on create)
    def deprecate_old_versions_after_create!
      @deprecate_old_versions_after_create = true
    end

    private
      def new_version_attrs(new_attrs)
        attr_builder = AttributeBuilder.new(self)
        attr_builder.attributes(new_attrs)
      end

      def deprecate_old_versions(current_version)
        versions.exclude(current_version).update_all(is_current_version: false)
      end

      def create_operation
        self.class.transaction do
          yield.tap do |created|
            deprecate_old_versions(created) if created.persisted?
          end
        end
      end

      def deprecate_old_versions_after_create?
        @deprecate_old_versions_after_create
      end

      def ensure_version_deprecation!
        if deprecate_old_versions_after_create?
          deprecate_old_versions(self)
        end
      end

      # This is required because a new version which has not been persisted
      # to the database breaks the normal ActiveRecord paradigm.
      # Because normally when a record has not yet been persisted
      # it can have no persisted has_one associations because there is no foriegn key.
      # In our case we have a foreign key because it was determined from the
      # previous version.
      #
      # This doesn't apply to composite has_one associations because they will
      # use a different foreign key to the parent version.
      #
      def preserve_has_one_associations_to(new_version)
        # Preserve simple has_one reflections
        self.class.reflections.select { |_, reflection|
          reflection.macro == :has_one
        }.each do |key, reflection|
          if !reflection.foreign_key.kind_of?(Array)
            new_version.send("#{key}=", self.send(key))
          end
        end
      end
  end
end
