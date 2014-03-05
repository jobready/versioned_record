module VersionedRecord
  module ClassMethods
    def current_versions
      where(is_current_version: true)
    end

    def exclude_current
      where(is_current_version: false)
    end

    def find(*args)
      if args.length == 1
        find_current(args.first)
      else
        super
      end
    end

    def find_current(id)
      current_versions.where(id: id).first
    end

    def exclude(record)
      where(id: record.id).where('version != ?', record.version)
    end
  end
end
