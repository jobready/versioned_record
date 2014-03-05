module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter

      # Provide versioned: true to create a versioned table
      # Note that schema.rb cannot be used with versioned tables
      def create_table(table_name, options = {})
        if options[:versioned] 
          super(table_name, options.merge(id: false)) do |table|
            table.column :id, :serial
            table.integer :version
            table.boolean :is_current_version
            yield(table)
          end
          add_index(table_name, [:id, :version], unique: true, name: "#{table_name}_versioned_pkey")
          execute("ALTER TABLE #{table_name} ADD PRIMARY KEY USING INDEX #{table_name}_versioned_pkey")
        else
          super
        end
      end
    end
  end
end
