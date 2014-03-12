module VersionedRecord
  # Builds a set of attributes for a new version of a record
  class AttributeBuilder

    # New Builder
    # @param [ActiveRecord::Base] record the record we are versioning
    def initialize(record)
      @record = record
    end

    # Get new attributes hash for the new version
    # Attributes missing in new_attrs will be filled in from 
    # the previous version (specified in the constructor)
    #
    # @param [Hash] new_attrs are the attributes we are changing in this version
    def attributes(new_attrs)
      @new_attrs = new_attrs.stringify_keys
      @record.attributes.merge(@new_attrs.merge({
        is_current_version: true,
        id:                 @record.id,
        version:            @record.version + 1
      }))
    end
  end
end
