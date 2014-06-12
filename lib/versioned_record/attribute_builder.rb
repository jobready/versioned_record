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
      @new_attrs = new_attrs.symbolize_keys
      attrs = original_attributes.merge(@new_attrs.merge({
        is_current_version: true,
        id:                 @record.id,
        version:            @record.version + 1
      }))
    end

    # The relevant attributes of the previous version
    # i.e: the record we initialized this builder with
    #
    # @return Hash excluding created_at and updated_at keys
    #
    def original_attributes
      @record.attributes.symbolize_keys.select do |(attr, _)|
        !%i(created_at updated_at).include?(attr)
      end
    end
  end
end
