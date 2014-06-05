module VersionedRecord
  module ClassMethods
    def versioned?
      true
    end

    # Scope to limit records to only the current versions
    def current_versions
      where(is_current_version: true)
    end

    # Scope to exclude current version from a query
    def exclude_current
      where(is_current_version: false)
    end

    # Finds a record as per ActiveRecord::Base
    # If only an ID is provided then it returns the current version for that ID
    # Otherwise, both an ID and a version can be provided
    #
    # @see ActiveRecord::Base#find
    # @see #find_current
    #
    # @example Single Argument
    #
    #     Model.find(1) => # The latest record
    #
    # @example An ID and a version
    #
    #     Model.find(1, 0) => # The first version
    #
    def find(*args)
      if args.length == 1 && !args.first.kind_of?(Array)
        find_current(args.first)
      else
        super
      end
    end

    # Find the current version of the record with the given ID
    # @param [Integer] id the record's ID
    # @raise [ActiveRecord::RecordNotFound] if no record with the given ID is found
    def find_current(id)
      current_versions.where(id: id).first.tap do |record|
        raise ActiveRecord::RecordNotFound unless record.present?
      end
    end

    # Scope to exclude the given record from results.
    # This is handy when retrieving all versions of a record except for one
    # Say when we are viewing all other versions to a given record
    #
    # @example
    #
    #     person = Person.find(1, 3)
    #     other_versions = person.versions.exclude(person)
    #
    def exclude(record)
      where(id: record._id).where.not(version: record.version)
    end
  end
end
