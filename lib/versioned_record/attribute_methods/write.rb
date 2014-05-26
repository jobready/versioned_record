module ActiveRecord
  module AttributeMethods
    module Write
      alias_method :write_attribute_original, :write_attribute

      def write_attribute(attr_name, value)
        #byebug if attr_name == 'contract_id' && Apprenticeship === self
        # We only have a single value to set, but an array was provided
        if !attr_name.kind_of?(Array) && value.kind_of?(Array)
          # Use just the ID and ignore the version
          write_attribute_original(attr_name, value[0])
        else
          write_attribute_original(attr_name, value)
        end
      end
    end
  end
end