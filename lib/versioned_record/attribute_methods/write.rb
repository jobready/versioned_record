module ActiveRecord
  module AttributeMethods
    module Write
      alias_method :write_attribute_original, :write_attribute

      def write_attribute(attr_name, value)
        # We only have a single value to set, but a composite key array was provided
        if !attr_name.kind_of?(Array) && value.kind_of?(CompositePrimaryKeys::CompositeKeys)
          # Use just the ID and ignore the version
          write_attribute_original(attr_name, value[0])
        else
          write_attribute_original(attr_name, value)
        end
      end
    end
  end
end
