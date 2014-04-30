module VersionedRecord
  module CompositePredicates

    # Lets say location belongs to a company and company is versioned
    # 
    #     class Company < ActiveRecord::Base
    #       include VersionedRecord
    #       has_many :locations
    #     end
    #
    #     class Location < ActiveRecord::Base
    #       belongs_to :company
    #     end
    #
    # When we want to load the company from the location we do:
    #
    #     location.company
    #
    # This will do:
    #
    #     Company.where(id: location.company.id, is_current_version: true)
    #
    # @param [Arel::Table] association_table the associated_table (in the example, company)
    # @param [Array,String] association_key the value of the pkey of associated_table (in the example, company)
    # @param [Arel::Table] table (in the example, location)
    # @param [Array,String] key reference to the association
    #
    def cpk_join_predicate(association_table, association_key, table, key)
      fields             = Array(key).map { |key| table[key] }
      association_fields = Array(association_key).map { |key| association_table[key] }

      if fields.size == 1
        eq_predicates = [ association_fields[0].eq(fields[0]), association_table[:is_current_version].eq(true) ]
        cpk_and_predicate(eq_predicates)
      else
        super
      end
    end
  end
end
